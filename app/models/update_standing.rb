class UpdateStanding

	def initialize(tournament, fixture)
		@tournament = tournament
		@fixture = fixture
	end

	def apply_changes
		#update standing for teams who just played, returns true or false on placing_change
		#to tell us whether position in table changed at all.
		placing_change1 = update_standing_for_team(@tournament.teams.find(@fixture.player1_id), 1)
		placing_change2 = update_standing_for_team(@tournament.teams.find(@fixture.player2_id), 2)
		update_other_standings if placing_change1 || placing_change2
		#check if this was last game of league. If so, update tournament to be completed.
		league_completed if @tournament.fixtures.where(completed: false).count == 0
	end

	def update_standing_for_team(team, player)
		standing = @tournament.standings.where(team_id: team.id).first

		# initialising need_to_update_table, but it is not modified at this stage
		# later on, add checks to determine whether update of table is required
		# previous attempts at such checks started to get clunky so were removed
		need_to_update_table = true 
		
		standing.games_played += 1
		if @fixture.winner_id == team.id
			standing.wins += 1
			standing.points += 3
		elsif @fixture.winner_id == -1
			standing.draws += 1
			standing.points += 1
		else
			standing.losses += 1
		end
		if player == 1
			standing.for += @fixture.player1_score
			standing.against += @fixture.player2_score
			standing.difference += @fixture.player1_score - @fixture.player2_score
		elsif player == 2
			standing.for += @fixture.player2_score
			standing.against += @fixture.player1_score
			standing.difference += @fixture.player2_score - @fixture.player1_score
		end
		standing.save
		need_to_update_table
	end

	def update_other_standings
		ordered_standings = @tournament.standings.order("points DESC, difference DESC")
		prev_standing = Object.new
		ordered_standings.each_with_index do |standing, index|
			standing.placing = index + 1
			standing.equal_placing = false
			if index != 0
				if (standing.points == prev_standing.points) && (standing.difference == prev_standing.difference)
					standing.placing = prev_standing.placing
					standing.equal_placing = true
					prev_standing.equal_placing = true
					prev_standing.save
				end
			end
			standing.save
			prev_standing = standing
		end
	end

	def league_completed
		@tournament.completed = true
		first_place = @tournament.standings.where(placing: 1)
		if first_place.equal_placing == false
			@tournament.winner_id = first_place.team_id
		end
		@tournament.save
	end
end
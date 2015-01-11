class UpdateStanding

	def initialize(tournament, fixture)
		@tournament = tournament
		@fixture = fixture
	end

	def apply_changes
		#update standing for teams who just played, returns true or false on placing_change
		#to tell us whether position in table changed at all.
		placing_change1 = update_standing_for_team(@tournament.teams.find(@fixture.player1_id))
		placing_change2 = update_standing_for_team(@tournament.teams.find(@fixture.player2_id))
		update_other_standings if placing_change1 || placing_change2
		#check if this was last game of league. If so, update tournament to be completed.
		league_completed if @tournament.fixtures.where(completed: false).count == 0
	end

	def update_standing_for_team(team)
		standing = @tournament.standings.where(team_id: team.id)
		standing.games_played += 1
		#if won
		#if lost
		#if draw
		#update for, against and difference
		#get resulting placing, including equal or not. 
		#check if this matches what was already there, then update. 
		#return true if above was a match, false if not. This is used to decide whether overall tournament
		#standings will be updated
	end

	def update_other_standings
		# order teams by points (reverse order), with secondary ordering by goal difference
		# set equal to false for all games to begin with. 
		# check if any have same points and difference as others, then give those an equal 
		# placing and set equal to true.
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
class UpdateStanding

	def initialize(tournament, fixture)
		@tournament = tournament
		@fixture = fixture
	end

	def apply_changes
		#update this teams standing in the tournament
		update_for_this_team
		#check if change has resulted in changes to other teams' standings
		update_other_standings
		#check if this was last game of league. If so, update tournament to be completed.
		league_completed
	end

	def update_for_this_team
	end

	def update_other_standings
	end

	def league_completed
	end
end
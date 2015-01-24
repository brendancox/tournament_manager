class UpdatePlayoff

	def initialize(tournament, fixture)
		@tournament = tournament
		@fixture = fixture
	end

	def apply_changes
		update_following_round unless @fixture.next_playoff_id.blank?
		tournament_completed if @tournament.fixtures.where(completed: false).count == 0
	end

	protected

	def update_following_round
		next_playoff = @tournament.fixtures.find(@fixture.next_playoff_id)
		# with using game_number here for checking whether preceding winner goes to player1 or 2
		# risk that if game number changes because a game is rescheduled to be before or after
		# another one. When rescheduling, may need to have a script that checks for referenced 
		# game numbers
		if @fixture.game_number == next_playoff.preceding_playoff_game_number1
			next_playoff.player1_id = @fixture.winner_id
		elsif @fixture.game_number == next_playoff.preceding_playoff_game_number2
			next_playoff.player2_id = @fixture.winner_id
		end
		next_playoff.save
	end

	def tournament_completed
		@tournament.completed = true
		@tournament.winner_id = @fixture.winner_id
		@tournament.save
	end
end
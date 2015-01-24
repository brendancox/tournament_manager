class FixturesController < ApplicationController

	def show
		fixture = Fixture.find(params[:id])
		@tournament = Tournament.find(fixture.tournament_id)
		@fixture = FixturesSet.new(@tournament, fixture).data[0]
	end

	def enter_result
		@fixture_record = Fixture.find(params[:id])
		@tournament = Tournament.find(@fixture_record.tournament_id)
		@fixture = FixturesSet.new(@tournament, @fixture_record).data[0]
	end

	def record_result
		fixture = Fixture.update(params[:id], record_result_params)
		fixture.completed = true
		if fixture.player1_score > fixture.player2_score
			fixture.winner_id = fixture.player1_id
		elsif fixture.player2_score > fixture.player1_score
			fixture.winner_id = fixture.player2_id
		else
			fixture.winner_id = -1  # winner_id is -1 for a draw
		end
		fixture.save
		tournament = Tournament.find(fixture.tournament_id)
		if tournament.format == "Playoff"
			update_competition_details = UpdatePlayoff.new(tournament, fixture)
		elsif tournament.format == "League"
			update_competition_details = UpdateStanding.new(tournament, fixture)
			if (tournament.fixtures.where(league_round: fixture.league_round, completed: false).count == 1)
				last_in_round = tournament.fixtures.where(league_round: fixture.league_round, completed: false).first
				if last_in_round.bye == true
					last_in_round.completed = true
					last_in_round.save
				end
			end
		end
		update_competition_details.apply_changes

		redirect_to fixture
	end

	private 

	def record_result_params
		params.require(:fixture).permit(:player1_score, :player2_score)
	end
end
class FixturesController < ApplicationController

	def show
		fixture = Fixture.find(params[:id])
		@tournament = Tournament.find(fixture.tournament_id)
		@fixture = FixturesSet.new(@tournament, fixture).data[0]
	end

	def edit
		@fixture_record = Fixture.find(params[:id])
		@tournament = Tournament.find(@fixture_record.tournament_id)
		@fixture = FixturesSet.new(@tournament, @fixture_record).data[0]
	end

	def update
		fixture = Fixture.find(params[:id])
		fixture.update(update_params)
		redirect_to fixture
	end

	def enter_result
		@fixture_record = Fixture.find(params[:id])
		@tournament = Tournament.find(@fixture_record.tournament_id)
		@fixture = FixturesSet.new(@tournament, @fixture_record).data[0]
	end

	def record_result
		fixture = Fixture.update(params[:id], record_result_params)
		fixture.completed = true
		if fixture.winner_id.blank?
			puts params[:fixture][:player1_score].class
			if fixture.player1_score > fixture.player2_score
				fixture.winner_id = fixture.player1_id
			elsif fixture.player2_score > fixture.player1_score
				fixture.winner_id = fixture.player2_id
			else
				fixture.winner_id = -1  # winner_id is -1 for a draw
			end
		end
		fixture.save
		tournament = Tournament.find(fixture.tournament_id)
		if tournament.format == "Playoffs"
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
		elsif tournament.format == "League then Playoffs"
			if fixture.league_round.blank?
				update_competition_details = UpdatePlayoff.new(tournament, fixture)
			else
				update_competition_details = UpdateStanding.new(tournament, fixture)
				if (tournament.fixtures.where(league_round: fixture.league_round, completed: false).count == 1)
					last_in_round = tournament.fixtures.where(league_round: fixture.league_round, completed: false).first
					if last_in_round.bye == true
						last_in_round.completed = true
						last_in_round.save
					end
				end
			end
		end
		update_competition_details.apply_changes

		if (tournament.format == "League then Playoffs") &&	!fixture.league_round.blank? && (tournament.fixtures.where('league_round is not null AND completed = ?', false).count == 0)
			puts 'UPDATING PLAYOFFS'
			progressing_teams = tournament.standings.order('placing ASC').limit(tournament.teams_in_playoffs).pluck(:team_id)
			tournament.fixtures.where('preceding_league_ranking1 is not null').each do |this_fixture|
				this_fixture.player1_id = progressing_teams[this_fixture.preceding_league_ranking1-1]
				this_fixture.save
			end
			tournament.fixtures.where('preceding_league_ranking2 is not null').each do |this_fixture|
				this_fixture.player2_id = progressing_teams[this_fixture.preceding_league_ranking2-1]
				this_fixture.save
			end
		end

		redirect_to fixture
	end

	private 

	def record_result_params
		params.require(:fixture).permit(:player1_score, :player2_score, :winner_id)
	end

	def update_params
		params.require(:fixture).permit(:id, :location, :referee, :start_time)
	end
end
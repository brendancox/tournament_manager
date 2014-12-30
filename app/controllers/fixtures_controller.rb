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
		fixture.save
		redirect_to fixture
	end

	private 

	def record_result_params
		params.require(:fixture).permit(:player1_score, :player2_score)
	end
end
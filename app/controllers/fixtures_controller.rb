class FixturesController < ApplicationController

	def show
		fixture = Fixture.find(params[:id])
		@tournament = Tournament.find(fixture.tournament_id)
		@fixture = FixturesSet.new(@tournament, fixture).data[0]
	end

	def enter_score
		fixture = Fixture.find(params[:id])
		@tournament = Tournament.find(fixture.tournament_id)
		@fixture = FixturesSet.new(@tournament, fixture).data[0]
		@scores
	end
end
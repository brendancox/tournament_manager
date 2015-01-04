require 'rails_helper'

describe "update rest of tournament" do
	context "after first round" do
		before do 
			load_factories
			@tournament = Tournament.first
			@tournament.update(team_ids: [1, 2, 3, 4])
			schedule = GeneratePlayoffSchedule.new(@tournament)
    	schedule.create
		end

		it "adds winning player ids to 2nd round game" do
			fixture = Fixture.first
			fixture.winner_id = fixture.player1_id
			fixture.completed = true
			fixture.save
			update_competition_details = UpdatePlayoff.new(@tournament, fixture)
			update_competition_details.apply_changes
			expect(Fixture.last.player1_id).to eq(Fixture.first.winner_id)
		end
	end

	context "after last round" do
		before do 
			load_factories
			@tournament = Tournament.first
			@tournament.update(team_ids: [1, 2])
			schedule = GeneratePlayoffSchedule.new(@tournament)
    	schedule.create
    	fixture = Fixture.first
			fixture.winner_id = fixture.player1_id
			fixture.completed = true
			fixture.save
			update_competition_details = UpdatePlayoff.new(@tournament, fixture)
			update_competition_details.apply_changes
		end

		it "records winner of tournament" do
			expect(@tournament.winner_id).not_to be_blank
		end

		it "records that tournament is complete" do
			expect(@tournament.completed).to eq(true)
		end
	end
end
require 'rails_helper'

describe "generate league schedules" do
	context "without byes" do 
		before :each do 
			load_factories
			tournament = Tournament.first
			tournament.update(team_ids: [1, 2, 3, 4])
		end

		subject { GenerateLeagueSchedule.new(Tournament.first) }

		it "runs the create method without errors" do
			expect {subject.create}.not_to raise_error
		end

		context "creates league fixtures" do
			before do 
				subject.create
			end

			it "includes correct number of fixtures" do
				expect(Tournament.first.fixtures.count).to eq(6)
			end
		end
	end

	context "with byes" do 
		before :each do 
			load_factories
			create(:extra_teams)
			tournament = Tournament.first
			tournament.update(team_ids: [1, 2, 3, 4, 5])
		end

		subject { GenerateLeagueSchedule.new(Tournament.first) }

		it "runs the create method without errors" do
			expect {subject.create}.not_to raise_error
		end

		context "creates league fixtures" do
			before do 
				subject.create
			end

			it "includes correct number of fixtures" do
				expect(Tournament.first.fixtures.count).to eq(15)
			end
		end
	end
end

require 'rails_helper'

# Private specs are ignored by default. See rails_helper for command excluding tests in this folder.

# These tests are kept as complicated code may need to be refactored from time to time, with
# benefit of testing existing methods as a starting point. 

# Relevant models will need private commented out. Alternatively, rspec-context-private gem 
# could be added to bundle. 

describe "generate playoff schedules - private methods", :private => true do
	before :each do 
		load_factories
		tournament = Tournament.first
		tournament.update(team_ids: [1, 2, 3, 4])
	end

	subject { GenerateSchedule.new(Tournament.first) }

	it "determines number of rounds" do
		expect(subject.determine_rounds).to eq(2)
	end

	it "determines number of games in subround" do
		subject.determine_rounds
		subject.games_in_subround
		expect(subject.games_in_subround).to eq(0)
	end

	context "first round fixtures" do
		before do 
			subject.determine_rounds
			subject.generate_first_round_fixtures
		end

		it "created" do
			expect(Fixture.count).to eq(2)
		end

		it "should assign one team to one fixture" do
			teams_array = [Fixture.first.player1_id, Fixture.first.player2_id,
				Fixture.last.player1_id, Fixture.last.player2_id]
			expect(teams_array.uniq.length).to eq(teams_array.length)
		end

		it "completed should be set to false" do
			expect(Fixture.first.completed).to eq(false)
		end

		it "should set first fixture for tomorrow 6pm" do
			tomorrow_at_six = Time.new.change(hour: 18) + 1.day
			expect(Fixture.first.start_time).to eq(tomorrow_at_six)
		end

		it "should set second fixture for 24 hours later" do 
			day_after_at_six = Time.new.change(hour: 18) + 2.day
			expect(Fixture.second.start_time).to eq(day_after_at_six)
		end

		it "should add playoff round number to fixtures" do
			expect(Fixture.first.playoff_round).to eq(1)
		end

	end

	context "second round fixtures" do
		before do 
			subject.determine_rounds
			subject.generate_first_round_fixtures
			subject.generate_remaining_fixtures
		end

		it "created" do
			expect(Fixture.last.playoff_round).to eq(2)
		end

		it "first round fixtures now show next_playoff_id" do
			expect(Fixture.first.next_playoff_id).to eq(Fixture.last.id)
		end
	end

	context "subround functions" do
		before do
			3.times {create(:extra_teams)}
			tournament = Tournament.first
			tournament.update(team_ids: [1, 2, 3, 4, 5, 6, 7])
			subject.determine_rounds
			subject.generate_first_round_fixtures
		end

		it "determines 2 subround fixtures" do
			expect(subject.games_in_subround).to eq(2)
		end

		context "generate subround fixtures" do
			before do
				subject.generate_subround_fixtures
			end

			it "creates subround fixtures" do
				expect(Fixture.where(playoff_round: 2).count).to eq(2)
			end

			it "odd team in first subround game was not in previous games" do
				first_round_teams = Array.new
				@round_1 = Fixture.where(playoff_round: 1)
				for x in 0...@round_1.count
					first_round_teams.push(@round_1[x].player1_id)
					first_round_teams.push(@round_1[x].player2_id)
				end
				expect(first_round_teams.include?(Fixture.where(playoff_round: 2).first.player1_id)).not_to eq(true)
			end

			it "creates 3rd round with 2^x games" do
				subject.generate_fixtures_following_subround
				expect(Fixture.where(playoff_round: 3).count).to eq(1)
			end
		end
	end
end
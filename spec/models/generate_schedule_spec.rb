require 'rails_helper'

describe "generate schedules" do
	before :each do 
		load_factories
		tournament = Tournament.first
		tournament.update(team_ids: [1, 2, 3, 4])
	end

	subject { GenerateSchedule.new(Tournament.first) }

	it "check teams added to tournament" do
		tournament = Tournament.first
		participant = tournament.teams.first
		expect(participant.name).to eq('Alpha')
	end

	it "determines number of rounds" do
		expect(subject.determine_rounds).to eq(2)
	end

	it "determines number of games in subround" do
		subject.determine_rounds
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
			teams_array = [Fixture.first.player1_id, Fixture.first.player2_id, \
				Fixture.last.player1_id, Fixture.last.player2_id]
			expect(teams_array.uniq.length).to eq(teams_array.length)
		end

		it "completed should be set to false" do
			expect(Fixture.first.completed).to eq(false)
		end

	end

	it "creates fixtures for second round" do
		pending
	end
end
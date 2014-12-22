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

	it "creates fixtures for first round" do
		subject.determine_rounds
		subject.generate_first_round_fixtures
		expect(Fixture.count).to eq(2)
	end

	it "creates fixtures for second round" do
		pending
	end
end
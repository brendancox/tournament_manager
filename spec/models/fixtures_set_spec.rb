require 'rails_helper'

describe "Fixtures Set" do
	before :each do 
		load_factories
		tournament = Tournament.first
		tournament.update(team_ids: [1, 2, 3, 4])
		schedule = GenerateSchedule.new(tournament)
    schedule.create
	end

	it "should return an array" do
		tournament = Tournament.first
    fixtures = FixturesSet.new(tournament).data
    expect(fixtures).to be_instance_of(Array)
  end

  it "should return a single element array if fixture argument is supplied" do
  	tournament = Tournament.first
  	fixture = Fixture.first
  	fixture = FixturesSet.new(tournament, fixture).data
  	expect(fixture.count).to eq(1)
  end
end
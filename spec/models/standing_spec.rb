require 'rails_helper'

describe Standing do 
	context "set to zero method" do
		before do 
			load_factories
			tournament = Tournament.first
			tournament.update(team_ids: [1, 2, 3, 4])
			tournament.teams.each do |team|
				standing = tournament.standings.new
	      standing.set_to_zero(team)
	      standing.save
    	end
    end

    it "creates 4 standings" do
    	expect(Standing.count).to eq(4)
    end

    it "adds team_id to each standing" do
    	team_id_array = Standing.all.pluck(:team_id)
    	expect(team_id_array).to eq([1, 2, 3, 4])
    end
  end
end
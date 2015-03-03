require 'rails_helper'

describe UpdateStanding do 
	before do 
		load_factories
		tournament = Tournament.first
		tournament.update(team_ids: [1, 2, 3, 4])
		GenerateLeagueSchedule.new(tournament).create
	end

	it "gives four standings initially with zero points" do
		expect(Standing.where(points: 0).count).to eq(4)
	end

	context "first game played - winner and loser" do 
		before do
			tournament = Tournament.first
			fixture = Fixture.first
			fixture.completed = true
			fixture.player1_score = 2
			fixture.player2_score = 1
			fixture.winner_id = fixture.player1_id
			fixture.save
			UpdateStanding.new(tournament, fixture).apply_changes
		end

		it "results in one team have 3 points" do
			expect(Standing.where(points: 3).count).to eq(1)
		end

		it "results in games_played = 1 for 2 standings" do 
			expect(Standing.where(games_played: 1).count).to eq(2)
		end

		it "puts one team in first place" do
			expect(Standing.where(placing: 1, equal_placing: false).count).to eq(1)
		end

		it "puts teams that haven't played second equal" do 
			expect(Standing.where(placing: 2, equal_placing: true).count).to eq(2)
		end

		it "puts losing team in last place" do
			expect(Standing.where(placing: 4, equal_placing: false).count).to eq(1)
		end

		context "second game played - draw" do
			before do 
				tournament = Tournament.first
				fixture = Fixture.offset(1).first
				fixture.completed = true
				fixture.player1_score = 3
				fixture.player2_score = 3
				fixture.winner_id = -1
				fixture.save
				UpdateStanding.new(tournament, fixture).apply_changes
			end

			it "at least one team has 1 point" do
				expect(Standing.where(points: 1).count).to be > 0
			end

			it "more teams have games_played" do 
				played_count = Standing.where(games_played: 1).count
				played_count += Standing.where(games_played: 2).count
				expect(played_count).to be > 2
			end
		end
	end
end

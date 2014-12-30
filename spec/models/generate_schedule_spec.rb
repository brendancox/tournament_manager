require 'rails_helper'

describe "generate playoff schedules" do
	before :each do 
		load_factories
		tournament = Tournament.first
		tournament.update(team_ids: [1, 2, 3, 4])
	end

	subject { GenerateSchedule.new(Tournament.first) }

	it "runs the create method without errors" do
		expect {subject.create}.not_to raise_error
	end

	context "first round fixtures" do
		before do 
			subject.create
		end

		it "created" do
			expect(Fixture.where(playoff_round: 1).count).to eq(2)
		end

		it "should assign one team to one fixture" do
			teams_array = [Fixture.where(playoff_round: 1).first.player1_id, 
				Fixture.where(playoff_round: 1).first.player2_id,
				Fixture.where(playoff_round: 1).last.player1_id, 
				Fixture.where(playoff_round: 1).last.player2_id]
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

	context "second round fixtures (where num of teams = 2^x)" do
		before do 
			subject.create
		end

		it "created" do
			expect(Fixture.last.playoff_round).to eq(2)
		end

		it "first round fixtures now show next_playoff_id" do
			expect(Fixture.first.next_playoff_id).to eq(Fixture.last.id)
		end
	end

	context "with 7 teams" do
		before do
			3.times {create(:extra_teams)}
			tournament = Tournament.first
			tournament.update(team_ids: [1, 2, 3, 4, 5, 6, 7])
			subject.create
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
			expect(Fixture.where(playoff_round: 3).count).to eq(1)
		end

	end

	context "full schedule - with 17 teams" do
		before do
			# load_playoff_numbers is in support/correct_numbers.rb.  This contains relevant number
			# of games each round given a certain number of teams in the playoffs, as worked out
			# indepedently from the code. 
			# Format is num_of_games[number_of_teams][playoff_round]
			@num_of_games = load_playoff_numbers
			@num_of_teams = 17
			(@num_of_teams - 4).times {create(:extra_teams)}
			tournament = Tournament.first
			tournament.update(team_ids: (1..@num_of_teams).to_a)
			subject.create
		end

		context "should create correct number of games in each round" do

			it "first round" do
				expect(Fixture.where(playoff_round: 1).count).to eq(@num_of_games[@num_of_teams][1])
			end

			it "second round" do
				expect(Fixture.where(playoff_round: 2).count).to eq(@num_of_games[@num_of_teams][2])
			end

			it "third round" do
				expect(Fixture.where(playoff_round: 3).count).to eq(@num_of_games[@num_of_teams][3])
			end

			it "fourth round" do
				expect(Fixture.where(playoff_round: 4).count).to eq(@num_of_games[@num_of_teams][4])
			end

			it "fifth round" do
				expect(Fixture.where(playoff_round: 5).count).to eq(@num_of_games[@num_of_teams][5])
			end
		end
	end
end
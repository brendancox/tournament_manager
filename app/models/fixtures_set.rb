class FixturesSet

	def initialize(tournament, *fixture)
		@tournament = tournament
		@fixtures = Array.new
		if fixture.blank?
			@tournament.fixtures.each_with_index do |fixture, index|
				add_fixtures_data(fixture, index)
			end
		else
			add_fixtures_data(fixture[0])
		end
	end

	def data
		@fixtures
	end

	def completed
		completed_fixtures = Array.new
		@fixtures.each do |fixture|
			if fixture[:completed]
				completed_fixtures.push(fixture)
			end
		end
		place_into_rounds(completed_fixtures)
	end

	def unplayed
		unplayed_fixtures = Array.new
		@fixtures.each do |fixture|
			unless fixture[:completed]
				unplayed_fixtures.push(fixture)
			end
		end
		place_into_rounds(unplayed_fixtures)
	end

	private

	def add_fixtures_data(fixture, index=0)
		@fixtures[index] = Hash.new
		@fixtures[index][:id] = fixture.id
		unless fixture.league_round.blank?
			@fixtures[index][:round] = fixture.league_round
		end
		unless fixture.playoff_round.blank?
			@fixtures[index][:round] = fixture.playoff_round
		end
		unless fixture.bye == true
			@fixtures[index][:game_number] = fixture.game_number
			add_fixture_time(fixture, index)
		end
		add_team_data(fixture, index)
		@fixtures[index][:completed] = fixture.completed
		if (@fixtures[index][:completed]) && (fixture.bye != true) 
			add_final_score_data(fixture, index)
		end
	end

	def add_fixture_time(fixture, index)
		# IMPORTANT: to keep in mind that localtime will show time based on timezone of the server.
		# To query users local time from database once devise has been added
		@fixtures[index][:time] = fixture.start_time.localtime.strftime('%-I:%M%p %A, %d %B %Y')
	end

	def add_team_data(fixture, index)
		if fixture.player1_id.blank?
  		@fixtures[index][:player1] = "Winner of Match #{fixture.preceding_playoff_game_number1}"
  	else
  		@fixtures[index][:player1] = @tournament.teams.find(fixture.player1_id).name
  	end
  	if fixture.bye == true
  		@fixtures[index][:bye] = true
		elsif fixture.player2_id.blank?
  		@fixtures[index][:player2] = "Winner of Match #{fixture.preceding_playoff_game_number2}"
  	else
  		@fixtures[index][:player2] = @tournament.teams.find(fixture.player2_id).name
  	end
	end

	def add_final_score_data(fixture, index)
		@fixtures[index][:player1_score] = fixture.player1_score
		@fixtures[index][:player2_score] = fixture.player2_score
		if @fixtures[index][:player1_score] > @fixtures[index][:player2_score]
			@fixtures[index][:winner] = @fixtures[index][:player1]
		elsif @fixtures[index][:player1_score] < @fixtures[index][:player2_score]
			@fixtures[index][:winner] = @fixtures[index][:player2]
		else 
			@fixtures[index][:draw] = true
		end
	end

	def place_into_rounds(fixtures_array)
		rounds_array = Array.new
		bye_this_round = Array.new
		prev_fixture_round = 0
		fixtures_array.each do |fixture|
			if prev_fixture_round == 0
				rounds_array.push([fixture[:round]])
				if fixture[:bye] == true
					bye_this_round.push(fixture)
				else
					rounds_array[-1][1] = [fixture]
				end
				prev_fixture_round = fixture[:round]
			elsif prev_fixture_round == fixture[:round]
				if fixture[:bye] == true
					bye_this_round.push(fixture)
				else
					if rounds_array[-1][1].blank?
						rounds_array[-1][1] = []
					end
					rounds_array[-1][1].push(fixture)
				end
				prev_fixture_round = fixture[:round]
			else
				if rounds_array[-1][1].blank?
					rounds_array[-1][1] = bye_this_round
				else
					rounds_array[-1][1].push(*bye_this_round)
				end
				bye_this_round = [] #clear array of byes for start of new round
				rounds_array.push([fixture[:round]])
				if fixture[:bye] == true
					bye_this_round.push(fixture)
				else
					rounds_array[-1][1] = [fixture]
				end
				prev_fixture_round = fixture[:round]
			end
		end
		unless bye_this_round.blank?
			if rounds_array[-1][1].blank?
				rounds_array[-1][1] = bye_this_round
			else
				rounds_array[-1][1].push(*bye_this_round)
			end
		end
		rounds_array
	end
end
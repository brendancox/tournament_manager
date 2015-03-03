class FixturesSet

	def initialize(tournament, *fixture)
		@tournament = tournament
		@fixtures = Array.new
		if fixture.blank?
			if (@tournament.format == "Playoffs") || (@tournament.format == "League then Playoffs")
				@final_round = @tournament.fixtures.order("playoff_round DESC").first.playoff_round
			end
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

	def final
		@fixtures.select {|game| game[:final] == true}[0]
	end

	def left_side
		final_game = final
		left_side_array = Array.new
		unless final_game[:preceding_game1].blank?
			left_side_array[0] = Array.new
			semi = @fixtures.select {|game| game[:game_number] == final_game[:preceding_game1]}[0]
			left_side_array[0].push(semi)
		end
		still_searching = true
		more_to_go = false
		round = 1
		following_game = 0
		while still_searching
			pre1 = left_side_array[round-1][following_game][:preceding_game1]
			pre2 = left_side_array[round-1][following_game][:preceding_game2]
			unless pre1 == -1
				if left_side_array[round].blank?
					left_side_array[round] = Array.new
				end
				game_to_add = @fixtures.select {|game| game[:game_number] == pre1}[0]
				left_side_array[round].push(game_to_add)
				if (game_to_add[:preceding_game1] != -1) || (game_to_add[:preceding_game2] != -1)
					more_to_go = true
				end
			end
			unless pre2 == -1
				if left_side_array[round].blank?
					left_side_array[round] = Array.new
				end
				game_to_add = @fixtures.select {|game| game[:game_number] == pre2}[0]
				left_side_array[round].push(game_to_add)
				if (game_to_add[:preceding_game1] != -1) || (game_to_add[:preceding_game2] != -1)
					more_to_go = true
				end
			end
			following_game += 1
			if left_side_array[round-1][following_game].blank? && more_to_go
				round += 1
				following_game = 0
			elsif left_side_array[round-1][following_game].blank? && !more_to_go
				still_searching = false
			end
		end
		left_side_array
	end

	def right_side
		final_game = final
		right_side_array = Array.new
		unless final_game[:preceding_game2].blank?
			right_side_array[0] = Array.new
			semi = @fixtures.select {|game| game[:game_number] == final_game[:preceding_game2]}[0]
			right_side_array[0].push(semi)
		end
		still_searching = true
		more_to_go = false
		round = 1
		following_game = 0
		while still_searching
			pre1 = right_side_array[round-1][following_game][:preceding_game1]
			pre2 = right_side_array[round-1][following_game][:preceding_game2]
			unless pre1 == -1
				if right_side_array[round].blank?
					right_side_array[round] = Array.new
				end
				game_to_add = @fixtures.select {|game| game[:game_number] == pre1}[0]
				right_side_array[round].push(game_to_add)
				if (game_to_add[:preceding_game1] != -1) || (game_to_add[:preceding_game2] != -1)
					more_to_go = true
				end
			end
			unless pre2 == -1
				if right_side_array[round].blank?
					right_side_array[round] = Array.new
				end
				game_to_add = @fixtures.select {|game| game[:game_number] == pre2}[0]
				right_side_array[round].push(game_to_add)
				if (game_to_add[:preceding_game1] != -1) || (game_to_add[:preceding_game2] != -1)
					more_to_go = true
				end
			end
			following_game += 1
			if right_side_array[round-1][following_game].blank? && more_to_go
				round += 1
				following_game = 0
			elsif right_side_array[round-1][following_game].blank? && !more_to_go
				still_searching = false
			end
		end
		right_side_array
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
		@fixtures[index][:location] = fixture.location
		@fixtures[index][:referee] = fixture.referee
		unless fixture.league_round.blank?
			@fixtures[index][:round] = fixture.league_round
		end
		unless fixture.playoff_round.blank?
			@fixtures[index][:round] = fixture.playoff_round
			@fixtures[index][:is_playoff] = true
		end
		unless fixture.bye == true
			@fixtures[index][:game_number] = fixture.game_number
			add_fixture_time(fixture, index)
		end
		add_team_data(fixture, index)
		if @final_round #only defined if tournament format is playoffs
			if fixture.playoff_round == @final_round
				@fixtures[index][:final] = true
			end
			if fixture.preceding_playoff_game_number1
				@fixtures[index][:preceding_game1] = fixture.preceding_playoff_game_number1
			else
				@fixtures[index][:preceding_game1] = -1 
			end
			if fixture.preceding_playoff_game_number2
				@fixtures[index][:preceding_game2] = fixture.preceding_playoff_game_number2
			else
				@fixtures[index][:preceding_game2] = -1
			end
		end
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
		if fixture.player1_id.blank? && fixture.preceding_playoff_game_number1.blank?
			@fixtures[index][:player1] = "League placing #{fixture.preceding_league_ranking1}"
		elsif fixture.player1_id.blank?
  		@fixtures[index][:player1] = "Winner of Match #{fixture.preceding_playoff_game_number1}"
  	else
  		@fixtures[index][:player1] = @tournament.teams.find(fixture.player1_id).name
  		@fixtures[index][:player1_id] = fixture.player1_id
  	end
  	if fixture.bye == true
  		@fixtures[index][:bye] = true
  	elsif fixture.player2_id.blank? && fixture.preceding_playoff_game_number2.blank?
			@fixtures[index][:player2] = "League placing #{fixture.preceding_league_ranking2}"
		elsif fixture.player2_id.blank?
  		@fixtures[index][:player2] = "Winner of Match #{fixture.preceding_playoff_game_number2}"
  	else
  		@fixtures[index][:player2] = @tournament.teams.find(fixture.player2_id).name
  		@fixtures[index][:player2_id] = fixture.player2_id
  	end
	end

	def add_final_score_data(fixture, index)
		@fixtures[index][:player1_score] = fixture.player1_score
		@fixtures[index][:player2_score] = fixture.player2_score
		if fixture.winner_id == fixture.player1_id
			@fixtures[index][:winner] = @fixtures[index][:player1]
		elsif fixture.winner_id == fixture.player2_id
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
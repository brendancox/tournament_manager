class GenerateLeagueSchedule

  def initialize(tournament)
  	@tournament = tournament
  end

  def create
  	#TO ADD: check for existing fixtures for this tournament

  	team_pairs_rounds = team_pairs_in_rounds2(@tournament)
  	generate_league_fixtures(team_pairs_rounds)
  end

  protected

  def generate_all_pairs(tournament)
  	team_ids = tournament.teams.all.pluck(:id) # might want to hold onto this array, so may 
    # output an object from this method. 
  	team_pairs = Array.new
  	for i in 0...team_ids.count
  		for j in (i+1)...team_ids.count
  			team_pairs.push([team_ids[i],team_ids[j]])
  		end
  	end
  	team_pairs
  end

  def team_pairs_in_rounds(tournament)
    pairs_array = generate_all_pairs(tournament).shuffle

    # check if odd number of teams as this means there will be a bye for a team each round

    if tournament.teams.count.odd?
      byes = tournament.teams.all.pluck(:id)
      games_per_round = tournament.teams.length / 2
      rounds = tournament.teams.count
    else
      games_per_round = tournament.teams.length / 2
      rounds = tournament.teams.count - 1
    end
  
    pairs_in_rounds = Array.new
    for round in 1..rounds
      team_role_check = tournament.teams.all.pluck(:id)
      if byes
        bye = byes.delete_at(-1)
        team_role_check.delete(bye)
      end
      games_this_round = 0
      x = 0
      while games_this_round < games_per_round
        # Currently debugging when there are byes. If gets to x greater than pairs_array.length
        # may need to swap pairs out from another round
        # or find an algorithm for choosing the correct teams each time to allow for a bye
        # a given team at a later time

        if x >= pairs_array.length
          break
        elsif (team_role_check.include? pairs_array[x][0]) && (team_role_check.include? pairs_array[x][1])
          pairs_in_rounds.push(pairs_array[x] + [round])
          team_role_check.delete(pairs_array[x][0])
          team_role_check.delete(pairs_array[x][1])
          pairs_array.delete_at(x)
          games_this_round += 1
        else
          x += 1
        end
      end
    end
    # could set up arrays so that placing games in rounds can involve role check of teams in an 
    # array. can also have the same array with a variable marking if that team has had its bye
    # or not.
    
    # might create a new array in the object called in_rounds, have the third item in the array
    # be the round number.
    pairs_in_rounds
  end

  def team_pairs_in_rounds2(tournament)
    team_ids = tournament.teams.all.pluck(:id)
    fixed = team_ids[0]
    rest = team_ids[1..-1]

    # check if odd number of teams as this means there will be a bye for a team each round
    if tournament.teams.count.odd?
      games_per_round = (tournament.teams.length + 1) / 2
      rounds = tournament.teams.count
      rest.push(-1)
    else
      games_per_round = tournament.teams.length / 2
      rounds = tournament.teams.count - 1
    end
    
    pairs_in_rounds = Array.new
    for round in 1..rounds
      combined = []
      combined = [fixed] + rest
      for game in 0...games_per_round
        pairs_in_rounds.push([combined[game], combined[-1 - game], round])
      end

      # alter rest array
      last_of_rest = rest[-1]
      for x in (1..(rest.length-1)).to_a.reverse
        rest[x] = rest[x-1]
      end
      rest[0] = last_of_rest
    end

    pairs_in_rounds
  end

  def generate_league_fixtures(team_pairs_array)
  	first_game_start_time = Time.new.change(hour: 18) + 1.day
    game_count = 0
  	for i in 0...team_pairs_array.count
      if (team_pairs_array[i][0] == -1)  #bye
        new_fixture = @tournament.fixtures.new
        new_fixture.completed = false
        new_fixture.player1_id = team_pairs_array[i][1]
        new_fixture.league_round = team_pairs_array[i][2]
        new_fixture.bye = true
        new_fixture.save
      elsif (team_pairs_array[i][1] == -1)  #bye
        new_fixture = @tournament.fixtures.new
        new_fixture.completed = false
        new_fixture.player1_id = team_pairs_array[i][0]
        new_fixture.league_round = team_pairs_array[i][2]
        new_fixture.bye = true
        new_fixture.save
      else
    		new_fixture = @tournament.fixtures.new
    		new_fixture.completed = false
        new_fixture.location = @tournament.location
    		new_fixture.start_time = first_game_start_time + game_count.day
        # game count increases after start time - so that first game starts at first_game_start_time
        # game count increases before game number - so that game_number starts at 1
        game_count += 1
    		new_fixture.game_number = game_count
    		new_fixture.player1_id = team_pairs_array[i][0]
    		new_fixture.player2_id = team_pairs_array[i][1]
        new_fixture.league_round = team_pairs_array[i][2]
    		new_fixture.save
      end
  	end
  end
end
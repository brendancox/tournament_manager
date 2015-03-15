class GeneratePlayoffSchedule

  def initialize(tournament)
  	@tournament = tournament
  end

  def create_empty(number_of_teams = 0, first_game_number = 1, round_pre_sub = 1)
    @game_number = first_game_number #league then playoffs will already have game numbers
    @current_round = 1
    if number_of_teams == 0
      @remaining_teams = @tournament.teams.count
    else
      @remaining_teams = number_of_teams
    end
    first_game_start_time = Time.new.change(hour: 18) + 1.day

    # check if number of teams is 2^x (e.g. number of teams = 2, 4, 8, 16, etc) 
    if (Math.log2(@remaining_teams) - Math.log2(@remaining_teams).floor) > 0
      subround_required = true
    else
      subround_required = false
    end

    while @remaining_teams > 1
      remaining_teams_this_round = @remaining_teams
      if @current_round > 1
        preceding_round_fixtures = @tournament.fixtures.where(playoff_round: @current_round-1).pluck(:id)
      end
      i = 0
      unless subround_required && (@current_round == (round_pre_sub + 1))
        #create a round with no byes and doesn't need to take byes into account

        remaining_teams_this_round = @remaining_teams
        while remaining_teams_this_round > 1
          new_fixture = generate_next_fixture(first_game_start_time)
          new_fixture.save
          if @current_round > 1
            update_preceding(preceding_round_fixtures, new_fixture, i)
            i += 1
          end
          @remaining_teams -= 1
          remaining_teams_this_round -= 2
        end
      else  #subround (round to bring us to 2^x teams) and following round are created
        games_this_round = num_of_subround_games(@remaining_teams, round_pre_sub)
        unless games_this_round == 0
          while games_this_round > 0
            new_fixture = generate_next_fixture(first_game_start_time)
            new_fixture.save
            if @current_round > 1
              update_preceding(preceding_round_fixtures, new_fixture, i)
              i += 1
            end
            @remaining_teams -= 1
            games_this_round -= 1 
          end
          preceding_round_fixtures.concat(@tournament.fixtures.where(playoff_round: @current_round).pluck(:id))
          @current_round += 1
        end
        remaining_teams_this_round = @remaining_teams
        while remaining_teams_this_round > 1
          new_fixture = generate_next_fixture(first_game_start_time)
          new_fixture.save
          if @current_round > 1
            update_preceding(preceding_round_fixtures, new_fixture, i)
            i += 1
          end
          @remaining_teams -= 1
          remaining_teams_this_round -= 2
        end
      end
      @current_round += 1
    end
  end

  def assign_teams
    teams_to_add_to_fixtures = @tournament.teams.all.pluck(:id).shuffle
    i = 0
    game = 1
    while i < teams_to_add_to_fixtures.count
      # as long as byes do not have a game number, will not add teams to fixtures created as byes
      this_fixture = @tournament.fixtures.where(game_number: game).first
      if this_fixture.player1_id.blank? && this_fixture.preceding_playoff_game_number1.blank? 
        this_fixture.player1_id = teams_to_add_to_fixtures[i]
        this_fixture.save
        i += 1
      end
      if this_fixture.player2_id.blank? && this_fixture.preceding_playoff_game_number2.blank? 
        this_fixture.player2_id = teams_to_add_to_fixtures[i]
        this_fixture.save
        i += 1
      end
      game += 1
    end
  end

  private

  def num_of_subround_games(teams_count, round_pre_sub)
    #divide num of teams by 2, difference between ceiling of that (rounding up to allow for odd number)
    #and 2^(rounds-1) is the number of games in the subround.
    teams_in_following_round = 2**(Math.log2(teams_count).floor)
    num_of_games_in_subround = teams_count - teams_in_following_round
  end

  def update_preceding(preceding_playoffs_array, next_playoff, i)
    x = 0
    while (2*i+x) < preceding_playoffs_array.count
      preceding_fixture = @tournament.fixtures.find(preceding_playoffs_array[2*i+x])
      preceding_fixture.next_playoff_id = next_playoff.id
      preceding_fixture.save
      if x == 0
        next_playoff.preceding_playoff_game_number1 = preceding_fixture.game_number
        x += 1
      else
        next_playoff.preceding_playoff_game_number2 = preceding_fixture.game_number
        break
      end
    end
    next_playoff.save
  end

  def generate_next_fixture(first_game_start_time)
    new_fixture = @tournament.fixtures.new
    new_fixture.completed = false #should this be added to fixtures model (before save, if blank)
    new_fixture.location = @tournament.location
    new_fixture.start_time = first_game_start_time + (@game_number-1).day
    new_fixture.playoff_round = @current_round
    new_fixture.game_number = @game_number
    @game_number += 1
    #current_stage column was meant to be for final, semifinal etc. will add this later
    new_fixture
  end

  def generate_playoff_bye
    new_fixture = @tournament.fixtures.new
    new_fixture.completed = false
    new_fixture.playoff_round = @current_round
    new_fixture.bye = true
    new_fixture
  end
end
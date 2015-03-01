class GeneratePlayoffSchedule
  
  def initialize(tournament)
  	@tournament = tournament
  end

  def create
  	#TO ADD: check for existing fixtures for this tournament

    determine_rounds
    @game_number = 1
    generate_first_round_fixtures
    #calc num of games in subround. check odd_number_var. create fixtures for subround, if any.
    generate_subround_fixtures
    generate_fixtures_following_subround

    while @current_round <= @rounds
      generate_remaining_fixtures
    end
  end

  def create_empty(round_pre_sub = 1)
    @game_number = 1
    @current_round = 1
    @remaining_teams = @tournament.teams.count
    first_game_start_time = Time.new.change(hour: 18) + 1.day
    # To remove determine_rounds and alter games_in_subround, keeping for now to focus on
    # other functionality.  
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
        remaining_teams_this_round = @remaining_teams
        while remaining_teams_this_round > 1
          new_fixture = generate_next_fixture(first_game_start_time)
          new_fixture.save
          if @current_round > 1
            update_preceding_with_next_playoff_id(preceding_round_fixtures[2*i], new_fixture, 1)
            update_preceding_with_next_playoff_id(preceding_round_fixtures[2*i+1], new_fixture, 2)
            i += 1
          end
          @remaining_teams -= 1
          remaining_teams_this_round -= 2
        end
        if remaining_teams_this_round == 1
          new_fixture = generate_playoff_bye
          new_fixture.save
        end
      else  #subround and following round are created
        games_this_round = num_of_subround_games(@remaining_teams, round_pre_sub)
        unless games_this_round == 0
          while games_this_round > 0
            new_fixture = generate_next_fixture(first_game_start_time)
            new_fixture.save
            if @current_round > 1
              update_preceding_with_next_playoff_id(preceding_round_fixtures[2*i], new_fixture, 1)
              update_preceding_with_next_playoff_id(preceding_round_fixtures[2*i+1], new_fixture, 2)
              i += 1
            end
            @remaining_teams -= 1
            games_this_round -= 1 
          end
          @current_round += 1
        end
        preceding_round_fixtures.concat(@tournament.fixtures.where(playoff_round: @current_round-1).pluck(:id))
        remaining_teams_this_round = @remaining_teams
        while remaining_teams_this_round > 1
          new_fixture = generate_next_fixture(first_game_start_time)
          new_fixture.save
          if @current_round > 1
            update_preceding_with_next_playoff_id(preceding_round_fixtures[2*i], new_fixture, 1)
            update_preceding_with_next_playoff_id(preceding_round_fixtures[2*i+1], new_fixture, 2)
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

  def update_preceding_with_next_playoff_id(preceding_id, next_playoff, one_or_two)
    preceding_fixture = @tournament.fixtures.find(preceding_id)
    preceding_fixture.next_playoff_id = next_playoff.id
    preceding_fixture.save
    if one_or_two == 1
      next_playoff.preceding_playoff_game_number1 = preceding_fixture.game_number
    else
      next_playoff.preceding_playoff_game_number2 = preceding_fixture.game_number
    end
    next_playoff.save
  end
end

  def generate_next_fixture(first_game_start_time)
    new_fixture = @tournament.fixtures.new
    new_fixture.completed = false #should this be added to fixtures model (before save, if blank)
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




  # OLD METHODS

  def determine_rounds
    #work out number of rounds
    #The number does not include the subround. Check generate_subround_fixtures for
    #where @rounds is increased by 1 to account for this.
    @rounds = 0
    while (2**(@rounds+1) <= @tournament.teams.count)
      @rounds += 1
    end
    @rounds
  end

  def games_in_subround
    #divide num of teams by 2, difference between ceiling of that (rounding up to allow for odd number)
    #and 2^(rounds-1) is the number of games in the subround.
    teams_after_first_round = (@tournament.teams.count.to_f / 2).ceil
    teams_in_following_round = 2**(@rounds - 1)
    num_of_games_in_subround = teams_after_first_round - teams_in_following_round
  end

  def generate_first_round_fixtures
    @current_round = 1
    num_of_games = (@tournament.teams.count / 2).floor
    teams_to_add_to_fixtures = @tournament.teams.all.pluck(:id).shuffle
    first_game_start_time = Time.new.change(hour: 18) + 1.day
    for i in  0...num_of_games
      new_fixture = generate_new_fixture(first_game_start_time, i)
      new_fixture.player1_id = teams_to_add_to_fixtures[2*i]
      new_fixture.player2_id = teams_to_add_to_fixtures[2*i+1]
      new_fixture.save
    end
    #save id of team not playing if there is an odd number
    if teams_to_add_to_fixtures.length.odd?
      @odd_team_num = teams_to_add_to_fixtures.last
    end
    @current_round += 1
  end

  def generate_remaining_fixtures
    num_of_games = 2**(@rounds - @current_round)
    preceding_round_fixtures = @tournament.fixtures.where(playoff_round: @current_round -1).pluck(:id)
    first_game_start_time = @tournament.fixtures.last.start_time + 1.day
    for i in 0...num_of_games
      #create new fixture
      new_fixture = generate_new_fixture(first_game_start_time, i)
      new_fixture.save
      #set fixtures from preceding round to be playoff for new fixture
      update_preceding_with_next_playoff_id(preceding_round_fixtures[2*i], new_fixture, 1)
      update_preceding_with_next_playoff_id(preceding_round_fixtures[2*i+1], new_fixture, 2)
    end
    @current_round += 1
  end

  def generate_subround_fixtures
    num_of_games = games_in_subround
    if num_of_games > 0
      @rounds += 1 #there is now an extra round in the tournament beyond what was calculated
      preceding_round_fixtures = @tournament.fixtures.where(playoff_round: 1).pluck(:id)
      first_game_start_time = @tournament.fixtures.last.start_time + 1.day
      for i in 0...num_of_games
        new_fixture = generate_new_fixture(first_game_start_time, i)
        if (i == 0) && (@odd_team_num)
          new_fixture.player1_id = @odd_team_num
        end
        new_fixture.save
        unless (i == 0) && (@odd_team_num)
          update_preceding_with_next_playoff_id(preceding_round_fixtures[2*i], new_fixture, 1)
        end
        if (i == num_of_games - 1) && (@odd_team_num)
          update_preceding_with_next_playoff_id(preceding_round_fixtures[0], new_fixture, 2)
        else
          update_preceding_with_next_playoff_id(preceding_round_fixtures[2*i+1], new_fixture, 2)
        end
      end
      teams_in_following_round = 2**(@rounds - 2) #minus 2 here since @rounds gained +1 earlier
      num_of_teams_straight_to_third_round = teams_in_following_round - num_of_games
      @straight_to_third_round = preceding_round_fixtures.last(num_of_teams_straight_to_third_round)
      @current_round += 1
    end
  end

  def generate_fixtures_following_subround
    if @tournament.fixtures.where(playoff_round: 2).count > 0
      num_of_games = 2**(@rounds - 2) / 2#see note for teams_in_following_round
      preceding_round_fixtures = @tournament.fixtures.where(playoff_round: 2).pluck(:id)
      first_game_start_time = @tournament.fixtures.last.start_time + 1.day
      preceding_round_count = 0
      for i in 0...num_of_games
        new_fixture = generate_new_fixture(first_game_start_time, i)
        if 2*i < @straight_to_third_round.count
          new_fixture.preceding_playoff_game_number1 = @tournament.fixtures.find(@straight_to_third_round[2*i]).game_number
        else
          update_preceding_with_next_playoff_id(preceding_round_fixtures[preceding_round_count], new_fixture, 1)
          preceding_round_count += 1
        end
        if 2*i+1 < @straight_to_third_round.count
          new_fixture.preceding_playoff_game_number2 = @tournament.fixtures.find(@straight_to_third_round[2*i+1]).game_number
        else
          update_preceding_with_next_playoff_id(preceding_round_fixtures[preceding_round_count], new_fixture, 2)
          preceding_round_count += 1
        end
        new_fixture.save
      end
      @current_round += 1
    end
  end

  def generate_new_fixture(first_game_start_time, game_number)
    new_fixture = @tournament.fixtures.new
    new_fixture.completed = false #should this be added to fixtures model (before save, if blank)
    new_fixture.start_time = first_game_start_time + game_number.day
    new_fixture.playoff_round = @current_round
    new_fixture.game_number = @game_number
    @game_number += 1
    #current_stage column was meant to be for final, semifinal etc. will add this later
    new_fixture
  end


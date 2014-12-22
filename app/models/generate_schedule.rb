class GenerateSchedule
  
  def initialize(tournament)
  	@tournament = tournament
  end

  def create
  	#check for existing fixtures for this tournament

    determine_rounds
    generate_first_round_fixtures
    games_in_subround
    #create fixtures for first round. if odd num of teams, save team id in odd_number_var
    #calc num of games in subround. check odd_number_var. create fixtures for subround, if any. 
    generate_remaining_fixtures
  end

  def determine_rounds
    #work out number of rounds. after 1st round, play sub round,
    #such that the number of teams in the next round equals 2^rounds
    @rounds = 0
    while (2**(@rounds+1) <= @tournament.teams.count)
      @rounds += 1
    end
    @rounds
  end

  def games_in_subround
    #divide num of teams by 2, difference between ceiling of that (rounding up to allow for odd number)
    #and 2^(rounds-1) is the number of games in the subround. 
    teams_after_first_round = (@tournament.teams.count / 2).ceil
    teams_in_second_round = 2**(@rounds - 1)
    @games_in_subround = teams_after_first_round - teams_in_second_round
    if @games_in_subround > 0
      @rounds += 1
    end
    @games_in_subround
  end

  def generate_first_round_fixtures
    @current_round = 1
    num_of_games = (@tournament.teams.count / 2).floor
    teams_to_add_to_fixtures = @tournament.teams.all.pluck(:id).shuffle
    for i in  0...num_of_games
      new_fixture = @tournament.fixtures.new
      new_fixture.player1_id = teams_to_add_to_fixtures[2*i]
      new_fixture.player2_id = teams_to_add_to_fixtures[2*i+1]
      new_fixture.completed = false #should this be added to fixtures model (before save, if blank)
      new_fixture.playoff_round = 1
      #current_stage column was meant to be for final, semifinal etc. will add this later
      #would add next_playoff_id when generating second round
      new_fixture.start_time = Time.new.change(hour: 18) + (1 + i).day
      new_fixture.save
    end
    @current_round += 1
  end

  def generate_remaining_fixtures
    num_of_games = 2**(@rounds - @current_round)
    preceding_round_fixtures = @tournament.fixtures.where(playoff_round: @current_round -1).pluck(:id)
    last_round_final_start_time = @tournament.fixtures.last.start_time
    for i in 0...num_of_games
      #create new fixture
      new_fixture = @tournament.fixtures.new
      new_fixture.completed = false
      new_fixture.playoff_round = @current_round
      new_fixture.start_time = last_round_final_start_time + (1 + i).day
      new_fixture.save
      #set fixtures from preceding round to be playoff for new fixture
      preceding_fixture1 = @tournament.fixtures.find(preceding_round_fixtures[2*i])
      preceding_fixture2 = @tournament.fixtures.find(preceding_round_fixtures[2*i+1])
      preceding_fixture1.next_playoff_id = new_fixture.id
      preceding_fixture1.save
      preceding_fixture2.next_playoff_id = new_fixture.id
      preceding_fixture2.save
    end
  end
end
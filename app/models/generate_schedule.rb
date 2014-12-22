class GenerateSchedule
  
  def initialize(tournament)
  	@tournament = tournament
  end

  def create
  	#check for existing fixtures for this tournament

    determine_rounds
    generate_first_round_fixtures
    num_of_games_in_subround = games_in_subround
    #create fixtures for first round. if odd num of teams, save team id in odd_number_var
    #calc num of games in subround. check odd_number_var. create fixtures for subround, if any. 
    #create fixtures for remaining rounds. 
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
    num_of_games = teams_after_first_round - teams_in_second_round
  end

  def generate_first_round_fixtures
    num_of_games = (@tournament.teams.count / 2).floor
    #get ids of teams that need fixtures, randomise order and put into an array
    i = 0
    while i < num_of_games
      #generate new fixture
      #select first two teams in list of teams array
      #add first team to player 1, add second team to player 2.
      #set completed to false
      #set current_stage to round 1, will add a column 'playoff_round', which is an integer
      #will need to set date and time, so will need to add column 'start_time'
      #would add next_playoff_id when generating second round
      @tournament.fixtures.new 
  end

end
class GenerateSchedule
  
  def initialize(tournament)
  	@tournament = tournament
  end

  def create
  	#check for existing fixtures for this tournament

  	#work out number of rounds. after 1st round, play sub round,
  	#such that the number of teams in the next round equals 2^rounds
    determine_rounds
    #divide num of teams by 2, difference between ceiling of that (rounding up to allow for odd number)
    #and 2^(rounds-1) is the number of games in the subround. 
    #create fixtures for first round. if odd num of teams, save team id in odd_number_var
    #calc num of games in subround. check odd_number_var. create fixtures for subround, if any. 
    #create fixtures for remaining rounds. 
  end

  def determine_rounds
    rounds = 0
    while (2**(rounds+1) <= @tournament.teams.count)
      rounds += 1
    end
    rounds
  end
end
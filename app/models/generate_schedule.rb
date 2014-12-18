class GenerateSchedule
  
  def initialize(tournament)
  	@tournament = tournament
  end

  def create
  	#check for existing fixtures for this tournament

  	#work out number of rounds. after 1st round, play sub round,
  	#such that the number of teams in the next round equals 2^x
    determine_rounds
  end

  def determine_rounds
    rounds = 0
    while (2**(rounds+1) <= @tournament.teams.count)
      rounds += 1
    end
    rounds
  end
end
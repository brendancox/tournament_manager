class GenerateSchedule
  
  def initialize(tournament)
  	@tournament = tournament
  end

  def create
  	#check for existing fixtures for this tournament

  	#work out number of rounds. after 1st round, play sub round,
  	#such that the number of teams in the next round equals 2^x
  	x = 0
  	while (2**(x+1) <= @tournament.players.count)
  	  x++
  	end
  end
end
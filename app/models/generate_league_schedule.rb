class GenerateLeagueSchedule

  def initialize(tournament)
  	@tournament = tournament
  end

  def create
  	#TO ADD: check for existing fixtures for this tournament

  	team_pairs_array = generate_all_pairs(@tournament).shuffle
  	generate_league_fixtures(team_pairs_array)
  end

  protected

  def generate_all_pairs(tournament)
  	team_ids = tournament.teams.all.pluck(:id)
  	team_pairs = Array.new
  	for i in 0...team_ids.count
  		for j in (i+1)...team_ids.count
  			team_pairs.push([team_ids[i],team_ids[j]])
  		end
  	end
  	team_pairs
  end

  def generate_league_fixtures(team_pairs_array)
  	first_game_start_time = Time.new.change(hour: 18) + 1.day
  	for i in 0...team_pairs_array.count
  		new_fixture = @tournament.fixtures.new
  		new_fixture.completed = false
  		new_fixture.start_time = first_game_start_time + i.day
  		new_fixture.game_number = i + 1
  		new_fixture.player1_id = team_pairs_array[i][0]
  		new_fixture.player2_id = team_pairs_array[i][1]
  		new_fixture.save
  	end
  end
end
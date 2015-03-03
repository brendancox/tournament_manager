class GenerateLeaguePlayoffSchedule

  def initialize(tournament)
  	@tournament = tournament
  end

  def create
		GenerateLeagueSchedule.new(@tournament).create
    last_game_number = @tournament.fixtures.order("game_number ASC").last.game_number
    playoff_schedule = GeneratePlayoffSchedule.new(@tournament)
    playoff_schedule.create_empty(@tournament.teams_in_playoffs, last_game_number + 1)
    num_in_playoffs = @tournament.teams_in_playoffs # assigning to variable to lower db queries
    lowest_rank = num_in_playoffs
    highest_rank = 1
    team_rankings = Array.new
    while team_rankings.length < (num_in_playoffs-1)
      team_rankings.push(lowest_rank)
      unless lowest_rank == highest_rank
        team_rankings.push(highest_rank)
      end
      lowest_rank -= 1
      highest_rank += 1
    end
    playoffs = @tournament.fixtures.where('playoff_round is not null')
    i = 0
    while i < team_rankings.length
      playoffs.each do |playoff|
        unless playoff.game_number.blank?
          playoff.preceding_league_pool = 1
          unless playoff.preceding_playoff_game_number1
            playoff.preceding_league_ranking1 = team_rankings[i]
            playoff.save
            i += 1
          end
          unless playoff.preceding_playoff_game_number2
            playoff.preceding_league_ranking2 = team_rankings[i]
            playoff.save
            i += 1
          end
        end
      end
    end
  end

end
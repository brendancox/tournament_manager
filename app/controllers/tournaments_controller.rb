class TournamentsController < ApplicationController

  def new
  	@tournament = Tournament.new
  	@activity_select_options = Activity.all.pluck(:name, :id)
  end

  def create
  	tournament = Tournament.create(tournament_params)
  	redirect_to add_teams_path(tournament)
  end

  def update
  	tournament = Tournament.find(params[:id])
  	tournament.update(add_team_params)
  	redirect_to tournament
  end

  def show
  	@tournament = Tournament.find(params[:id])
    @fixtures = FixturesSet.new(@tournament)
    @standings = @tournament.standings.order("placing ASC, difference DESC")
    if @tournament.completed && !@tournament.winner_id.blank?
      @winner = @tournament.teams.find(@tournament.winner_id).name
    end
  end

  def index
  	@tournaments = Tournament.all
  end

  def add_teams
  	@tournament = Tournament.find(params[:id])
  	@teams = Team.all
  end

  def generate_schedule
  	tournament = Tournament.update(params[:id], add_team_params)
    if tournament.format == "Playoffs"
      schedule = GeneratePlayoffSchedule.new(tournament)
      schedule.create_empty
      schedule.assign_teams
    elsif tournament.format == "League"
      GenerateLeagueSchedule.new(tournament).create
    elsif tournament.format == "League then Playoffs"
      GenerateLeagueSchedule.new(tournament).create
      last_game_number = tournament.fixtures.order("game_number ASC").last.game_number
      playoff_schedule = GeneratePlayoffSchedule.new(tournament)
      playoff_schedule.create_empty(tournament.teams_in_playoffs, last_game_number + 1)
      num_in_playoffs = tournament.teams_in_playoffs # assigning to variable to lower db queries
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
      playoffs = tournament.fixtures.where('playoff_round is not null')
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
      
  	redirect_to tournament
  end

  private

  def tournament_params
  	params.require(:tournament).permit(:name, :activity_id, :format, :teams_in_playoffs, :organisation, :location)
  end

  def add_team_params
  	params.require(:tournament).permit(:id, team_ids: [])
  end

end
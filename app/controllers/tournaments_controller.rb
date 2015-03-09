class TournamentsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]

  def new
  	@tournament = current_user.tournaments.new
  	@activity_select_options = Activity.all.pluck(:name, :id)
  end

  def create
     
    tournament = current_user.tournaments.create(tournament_params)
    if tournament.valid?
  	  redirect_to add_teams_path(tournament)
    else
      redirect_to new_tournament_path
    end
  end

  def update
  	tournament = current_user.tournaments.find(params[:id])
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
  	@tournament = current_user.tournaments.find(params[:id])
  	@teams = current_user.teams.all
  end

  def generate_schedule
    tournament = current_user.tournaments.find(params[:id])
    puts add_team_params[:team_ids].count
    if add_team_params[:team_ids].count < 2
      redirect_to add_teams_path(tournament)
    else
    	tournament.update(add_team_params)
      if tournament.format == "Playoffs"
        schedule = GeneratePlayoffSchedule.new(tournament)
        schedule.create_empty
        schedule.assign_teams
      elsif tournament.format == "League"
        GenerateLeagueSchedule.new(tournament).create
      elsif tournament.format == "League then Playoffs"
        GenerateLeaguePlayoffSchedule.new(tournament).create
      end
      redirect_to tournament
    end	
  end

  def update_schedule
    @tournament = current_user.tournaments.find(params[:id])
    @fixtures = FixturesSet.new(@tournament)
  end

  private

  def tournament_params
  	params.require(:tournament).permit(:name, :activity_id, :format, :teams_in_playoffs, :organisation, :location)
  end

  def add_team_params
  	params.require(:tournament).permit(:id, team_ids: [])
    team_ids = params[:tournament][:team_ids]
    team_ids.uniq!
    team_ids.delete('-1')
    {team_ids: team_ids}
  end
end
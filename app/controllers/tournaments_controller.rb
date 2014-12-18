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
  end

  def index
  	@tournaments = Tournament.all
  end

  def add_teams
  	@tournament = Tournament.find(params[:id])
  	@teams = Team.all
  end

  def generate_schedule
  	tournament = Tournament.find(params[:id])
  	tournament.update(add_team_params)
  	redirect_to tournament
  end

  private

  def tournament_params
  	params.require(:tournament).permit(:name, :activity_id)
  end

  def add_team_params
  	params.require(:tournament).permit(:id, team_ids: [])
  end

end
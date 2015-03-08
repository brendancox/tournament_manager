class TeamsController < ApplicationController

  before_action :authenticate_user!

  def new
  	@team = Team.new
  end

  def create
  	team = Team.create(team_params)
  	redirect_to team
  end

  def show
  	@team = Team.find(params[:id])
  end

  def index
  	@teams = Team.all
  end

  def add_team_json
    team = current_user.teams.create(name: params[:team][:name])
    respond_to do |format|
      format.json {render json: team.to_json(only: :id)}
    end
  end

  private

  def team_params
  	params.require(:team).permit(:name)
  end

end
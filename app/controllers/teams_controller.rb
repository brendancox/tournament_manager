class TeamsController < ApplicationController

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

  private

  def team_params
  	params.require(:team).permit(:name)
  end

end
class TournamentsController < ApplicationController

  def new
  	@tournament = Tournament.new
  	@activity_select_options = Activity.all.pluck(:name, :id)
  end

  def create
  	tournament = Tournament.create(tournament_params)
  	redirect_to tournament
  end

  def show
  	@tournament = Tournament.find(params[:id])
  end

  def index
  	@tournaments = Tournament.all
  end

  private

  def tournament_params
  	params.require(:tournament).permit(:name, :activity_id, :num_of_teams)
  end

end
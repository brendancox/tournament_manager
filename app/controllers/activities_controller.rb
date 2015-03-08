class ActivitiesController < ApplicationController

  before_action :authenticate_user!

  def new
  	@activity = Activity.new
  end

  def create
  	activity = Activity.create(activity_params)
  	redirect_to activity
  end

  def show
  	@activity = Activity.find(params[:id])
  end

  def index
  	@activities = Activity.all
  end

  private

  def activity_params
  	params.require(:activity).permit(:name)
  end

end
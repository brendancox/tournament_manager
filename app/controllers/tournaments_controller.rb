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
    if @tournament.completed
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
    elsif tournament.format == "League"
      schedule = GenerateLeagueSchedule.new(tournament)
      tournament.teams.each do |team|
        # may want to confirm team does not already have a standing for this competition - if 
        # this is not checked in model before saving. 
        standing = tournament.standings.new
        standing.set_to_zero(team)
        standing.save
      end
    end
    schedule.create
  	redirect_to tournament
  end

  private

  def tournament_params
  	params.require(:tournament).permit(:name, :activity_id, :format)
  end

  def add_team_params
  	params.require(:tournament).permit(:id, team_ids: [])
  end

end
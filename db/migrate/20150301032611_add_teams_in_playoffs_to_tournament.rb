class AddTeamsInPlayoffsToTournament < ActiveRecord::Migration
  def change
  	add_column :tournaments, :teams_in_playoffs, :integer
  end
end

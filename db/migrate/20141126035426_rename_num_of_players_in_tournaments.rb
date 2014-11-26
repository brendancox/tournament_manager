class RenameNumOfPlayersInTournaments < ActiveRecord::Migration
  def change
    rename_column :tournaments, :num_of_players, :num_of_teams
  end
end

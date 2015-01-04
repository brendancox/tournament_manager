class AddTypeToTournament < ActiveRecord::Migration
  def change
  	add_column :tournaments, :type, :string
  	remove_column :tournaments, :num_of_teams
  end
end

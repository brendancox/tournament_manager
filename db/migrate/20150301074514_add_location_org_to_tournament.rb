class AddLocationOrgToTournament < ActiveRecord::Migration
  def change
  	add_column :tournaments, :location, :string
  	add_column :tournaments, :organisation, :string
  end
end

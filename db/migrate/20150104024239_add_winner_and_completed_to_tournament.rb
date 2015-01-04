class AddWinnerAndCompletedToTournament < ActiveRecord::Migration
  def change
  	add_column :tournaments, :winner_id, :integer
  	add_column :tournaments, :completed, :boolean
  end
end

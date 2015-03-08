class AddUserIdToTournament < ActiveRecord::Migration
  def change
  	add_column :tournaments, :user_id, :integer
  end
end

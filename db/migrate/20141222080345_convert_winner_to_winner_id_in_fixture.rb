class ConvertWinnerToWinnerIdInFixture < ActiveRecord::Migration
  def change
  	remove_column :fixtures, :winner
  	add_column :fixtures, :winner_id, :integer
  end
end

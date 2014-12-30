class AddGameNumberAndPrecedingGameToFixture < ActiveRecord::Migration
  def change
  	add_column :fixtures, :game_number, :integer
  	add_column :fixtures, :preceding_playoff_game_number, :integer
  end
end

class TwoColumnsForPrecedingPlayoffInFixture < ActiveRecord::Migration
  def change
  	rename_column :fixtures, :preceding_playoff_game_number, :preceding_playoff_game_number1
  	add_column :fixtures, :preceding_playoff_game_number2, :integer
  end
end

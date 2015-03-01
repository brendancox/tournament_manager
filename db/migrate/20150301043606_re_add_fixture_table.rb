class ReAddFixtureTable < ActiveRecord::Migration
  def change
  	create_table :fixtures do |t|
  		t.integer :tournament_id
  		t.integer :player1_id
  		t.integer :player1_score
  		t.integer :player2_id
  		t.integer :player2_score
  		t.boolean :completed
  		t.string :current_stage
  		t.integer :next_playoff_id
  		t.datetime :start_time
  		t.integer :playoff_round
  		t.integer :winner_id
  		t.integer :game_number
  		t.integer :preceding_playoff_game_number1
  		t.integer :preceding_playoff_game_number2
  		t.integer :league_round
  		t.boolean :bye
  		t.integer :preceding_league_pool
  		t.integer :preceding_league_ranking1
  		t.integer :preceding_league_ranking2

  		t.timestamps
  	end
  end
end

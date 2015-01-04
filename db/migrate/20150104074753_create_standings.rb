class CreateStandings < ActiveRecord::Migration
  def change
    create_table :standings do |t|
    	t.integer :tournament_id
    	t.integer :team_id
    	t.integer :points
    	t.integer :for
    	t.integer :against
    	t.integer :difference
    	t.integer :wins
    	t.integer	:draws
    	t.integer :losses
    	t.integer :games_played
    	t.integer :placing
    	t.boolean :equal_placing

      t.timestamps
    end
  end
end

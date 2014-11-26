class CreateFixtures < ActiveRecord::Migration
  def change
    create_table :fixtures do |t|
      t.integer :tournament_id
      t.integer :player1_id
      t.integer :player1_score
      t.integer :player2_id
      t.integer :player2_score
      t.boolean :completed
      t.string :winner
      t.string :current_stage
      t.integer :next_playoff_id

      t.timestamps
    end
  end
end

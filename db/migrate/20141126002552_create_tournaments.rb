class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.integer :activity_id
      t.integer :num_of_players
      
      t.timestamps
    end
  end
end

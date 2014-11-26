class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.integer :tournament_id
      t.integer :player_id

      t.timestamps
    end
  end
end

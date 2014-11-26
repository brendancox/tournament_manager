class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.first_name
      t.last_name

      t.timestamps
    end
  end
end

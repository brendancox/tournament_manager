class CreateTableUsersTeams < ActiveRecord::Migration
  def change
    create_table :users_teams do |t|
    	t.belongs_to :users, index: true
    	t.belongs_to :teams, index: true
    end
  end
end

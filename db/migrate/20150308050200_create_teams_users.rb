class CreateTeamsUsers < ActiveRecord::Migration
  def change
    create_table :teams_users do |t|
    	t.belongs_to :teams, index: true
    	t.belongs_to :users, index: true
    end
  end
end

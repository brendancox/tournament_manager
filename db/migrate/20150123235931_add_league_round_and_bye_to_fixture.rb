class AddLeagueRoundAndByeToFixture < ActiveRecord::Migration
  def change
  	add_column :fixtures, :league_round, :integer
  	add_column :fixtures, :bye, :boolean
  end
end

class AddPrecedingLeagueColumnsToFixture < ActiveRecord::Migration
  def change
  	add_column :fixtures, :preceding_league_pool, :integer
  	add_column :fixtures, :preceding_league_ranking, :integer
  end
end

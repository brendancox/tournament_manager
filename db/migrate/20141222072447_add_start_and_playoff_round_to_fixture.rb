class AddStartAndPlayoffRoundToFixture < ActiveRecord::Migration
  def change
  	add_column :fixtures, :start_time, :datetime
  	add_column :fixtures, :playoff_round, :integer
  end
end

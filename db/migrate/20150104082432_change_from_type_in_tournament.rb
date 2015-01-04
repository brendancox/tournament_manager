class ChangeFromTypeInTournament < ActiveRecord::Migration
  def change
  	rename_column :tournaments, :type, :format
  end
end

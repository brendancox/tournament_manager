class RenamePlayerToTeamInParticipants < ActiveRecord::Migration
  def change
  	rename_column :participants, :player_id, :team_id
  end
end

class Standing < ActiveRecord::Base
	belongs_to :tournament
	belongs_to :team

	def set_to_zero(team)
		# as this starts teams on 1st equal, would only do set_to_zero as is
    # when adding 1st lot of teams. Either that, or may need to compare against
    # rest of competition and adjust placing as necessary. 
    # also risk that team already has a standing when first lot of teams added
    # should validate for uniqueness of team id in that tournaments standings.
		self.team_id = team.id
		self.points = 0
		self.for = 0
		self.against = 0
		self.difference = 0
		self.wins = 0
		self.draws = 0
		self.losses = 0
		self.games_played = 0
		self.placing = 1
		self.equal_placing = true
	end
end

def load_playoff_numbers
	#num_of_games[team_number][playoff_round] tells how many games in that round for
	#that number of teams
	#0 in first field so that the above readable format can apply. may use this for number of subround
	#games 
	num_of_games = Array.new 
	num_of_games[4] = [0,2,1]
	num_of_games[7] = [0,3,0,2,1]
	num_of_games[17] = [0,9,1,4,2,1]  #including bye
	num_of_games
end
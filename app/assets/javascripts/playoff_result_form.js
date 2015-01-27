
$(document).on('ready page:load', function(){
	if ($('#tieBreaker').length) {
		$('form').submit(function(event){
				score1 = $('#fixture_player1_score').val();
				score2 = $('#fixture_player2_score').val();
				radio = $('[name="fixture[winner_id]"]:checked').length;
				if ((score1 == score2) && (radio == 0)) {
					event.preventDefault;
					$('#tieBreaker').show();
					return false;
				}
		});
	}
});
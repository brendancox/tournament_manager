$(document).on('ready page:load', function(){
	$('#tournament_format').change(function(){
		if ($('#tournament_format option:selected').text() === 'League then Playoffs')
		{
			$('#choose_num_in_playoffs').show();
		}
		else
		{
			$('#choose_num_in_playoffs').hide();
		}
	})
});
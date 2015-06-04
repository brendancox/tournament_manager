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
	});
	$('.requiredFieldsButton').click(function(e){
		var requiredNotComplete = false;
		$('.required').each(function(){
			if ($(this).val() === ''){
				$(this).css('border-color', 'red');
				$('.required-fields-message').show();
				requiredNotComplete = true;
			}
		});
		if (requiredNotComplete){
			e.preventDefault();
			return false;
		}
	});
});
$(document).on('ready page:load', function(){

	$('.datetimepicker1').on('dp.change', function(){
		this_entry = $(this);
		if (this_entry.hasClass('scheduleChangeTime'))
		{
			fixture_id = this_entry.prop('id');
			console.log(fixture_id);
			new_time = this_entry.val();
			$.ajax({
				type:'put',
				url: '/update_details',
				data: {fixture: {id: fixture_id, time: new_time}},
				dataType: 'json', 
				success: console.log('success')
			});
		}
	});
});
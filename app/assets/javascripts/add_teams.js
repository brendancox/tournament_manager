$(document).on('ready page:load', function(){

	$('form').on('change', '.add_team_select', function(){
		this_select = $(this);
		parent_div = this_select.parent();
		parent_div.find('.add_team_hidden').val(this_select.val());
		parent_div.find('.add_team_text').val(parent_div.find('.add_team_select option:selected').text());
	});

	$('form').on('change', '.add_team_text', function(){
		parent_div = $(this).parent();
		if ((parent_div.find('.add_team_hidden').val()) !== '-1')
		{
			parent_div.find('.add_team_hidden').val(-1);
			parent_div.find(".add_team_select option[value='']").attr('selected', true);
		}
	});

	$('.new_add_team_field').click(function(event){
		event.preventDefault();
		var newDiv = $('.add_team_div:last').clone();
		$('.add_team_div').last().after(newDiv);
		createdDiv = $('.add_team_div').last();
		createdDiv.find('.add_team_text').val('');
		createdDiv.find(".add_team_select option[value='']").attr('selected', true);
		createdDiv.find('.add_team_hidden').val(-1);
	})

	$('.add_team_button').click(function(event){
		$('.add_team_button').hide();
		var teams_array = [];
		tourn_id = $('.edit_tournament').attr('id')[16];
		$('.add_team_div').each(function(){
			parent_div = $(this);
			if (((parent_div.find('.add_team_text').val()) !== ""))
			{
				var team_name = parent_div.find('.add_team_text').val();
				var team_id = parent_div.find('.add_team_hidden').val();
				teams_array.push({name: team_name, id: team_id});
			}

		});
		$.ajax({
			type:'patch',
			url: 'generate_schedule',
			data: {team: teams_array},
			dataType: 'json',
			async: false,
			success: function(json){
			}
		});
	});

});
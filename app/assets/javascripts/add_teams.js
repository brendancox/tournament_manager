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
		$('.add_team_div').each(function(){
			parent_div = $(this);
			if (((parent_div.find('.add_team_hidden').val()) === '-1') && ((parent_div.find('.add_team_text').val()) !== ""))
			{
				team_name = parent_div.find('.add_team_text').val();
				$.ajax({
					type:'put',
					url: '/add_team_json',
					data: {team: {name: team_name}},
					dataType: 'json',
					async: false,
					success: function(json){
						parent_div.find('.add_team_hidden').val(json.id);
					}
				});
			}
		});
		$('.add_team_button').hide();
		$('.add_team_submit').show();
		$('.add_team_submit').removeClass('hidden');
	});

});
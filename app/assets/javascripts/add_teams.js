$(document).on('ready page:load', function(){

	$('.add_team_select').change(function(){
		this_select = $(this);
		parent_div = this_select.parent();
		parent_div.find('.add_team_hidden').val(this_select.val());
		parent_div.find('.add_team_text').val(parent_div.find('.add_team_select option:selected').text());
	});

	$('.add_team_text').change(function(){
		parent_div = $(this).parent();
		if ((parent_div.find('.add_team_hidden').val()) !== '-1')
		{
			parent_div.find('.add_team_hidden').val(-1);
			parent_div.find(".add_team_select option[value='']").attr('selected', true);
		}
	});

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
	});

});
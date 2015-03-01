$(document).on('ready page:load', function(){
	jQuery('.datetimepicker').datetimepicker({
		format:'d.m.Y H:i',
		inline: true,
		step: 15
	});
});


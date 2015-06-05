$(document).on('ready page:load', function(){

	$('.sortable, .placeHolderList').sortable({
		connectWith: '.sortable',
		placeholder: 'ui-state-highlight',
    receive: function(event, ui) {
    // so if > 10
    if ($(this).children().length > 1) {
        //ui.sender: will cancel the change.
        //Useful in the 'receive' callback.
        $(ui.sender).sortable('cancel');
    	}
  	}
	});

});
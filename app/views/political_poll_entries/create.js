console.log("received entry");
$("#loading").fadeIn().hide();
$("#poll_submitted").fadeIn();
$("#new_political_poll_entry").find("input, select").each(function(){
	$(this).attr('disabled', 'disabled');
});
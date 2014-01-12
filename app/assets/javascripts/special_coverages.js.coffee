# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$('select').chosen({ allow_single_deselect: true })
	$('#clear_post').click ->
		$('#sc_new_update').clearForm()
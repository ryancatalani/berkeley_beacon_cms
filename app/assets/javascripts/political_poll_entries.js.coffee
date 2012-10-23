# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

	$("#new_political_poll_entry").submit ->
		$("#loading").fadeIn()
		return true

	$("#new_political_poll_entry").find("#email").keypress (e) -> 
		v = $(this).val()
		if e.which == 64 or v.indexOf("@") != -1
			$("#email_username_alert").slideDown()

	$("#new_political_poll_entry").find("#email").blur ->
		v = $(this).val()
		if v.indexOf("@") != -1
			$("#email_username_alert").slideDown()

	$("#new_political_poll_entry").find('input, textarea').placeholder()

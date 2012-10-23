# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$("#new_political_poll_entry").submit ->
	$("#poll_loading").fadeIn()
	return true

$("#new_political_poll_entry").find('input, textarea').placeholder()

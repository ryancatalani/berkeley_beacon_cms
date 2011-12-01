# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$("#new_mediafile").submit ->
		if $("#mediafile_title").val() == "" or $("#mediafile_description").val() == ""
			alert("Oops, there was a problem. Make sure you filled out everything.")
			return false
		else
			$("#loading").fadeIn()
			return true
	$("#sourcetype_in").click ->
		$("#source_out_field").fadeToggle()
		$("#source_in_field").fadeToggle()
	$("#sourcetype_out").click ->
		$("#source_out_field").fadeToggle()
		$("#source_in_field").fadeToggle()
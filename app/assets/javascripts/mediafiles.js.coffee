# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$("#new_mediafile").submit ->
		if $("#mediafile_title").val() == ""
			alert("Oops, there was a problem. Make sure you filled out the caption.")
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
	$("#uploaded_files").on("click", ".show_mediafile_url", (e) ->
		$(this).siblings(".mediafile_url").slideToggle()
		e.preventDefault()
	)
	$("#uploaded_files").on("click", ".delete_mediafile", (e) ->
		$(this).parent().slideUp()
		del_id = '#' + $(this).attr('id').substr(7)
		$(del_id).remove()
		e.preventDefault()
	)
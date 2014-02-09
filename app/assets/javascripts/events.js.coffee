# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

	handle_ajax_error = (response) ->
		try
			msg = jQuery.parseJSON(response.responseText)
			return msg.error.toLowerCase()
		catch e
			return "There was an unknown error or the request timed out.  Please try again later."

	firstError = true
	$("#new_event").on "ajax:error", (data, xhr, response, n4, n5) ->
		# console.log xhr.responseText
		if firstError
			$("#new_event_errors").hide()
			firstError = false
		else
			$("#new_event_errors").slideUp()
		$("#new_event_errors").html("Sorry, there were some errors: #{ handle_ajax_error(xhr) }")
		$("#new_event_errors").slideDown();

	$("#new_event").submit (e) ->
		anyErrors = false
		e.preventDefault()
		$('#new_event_success').slideUp()
		$(this).find('input, textarea').each ->
			return if $(this).attr('id') == 'event_image'
			$(this).removeClass('form_error')
			if $(this).val() == ''
				$(this).addClass('form_error')
				anyErrors = true
			if $(this).attr('id') == 'event_organizer_email' && $(this).val().length > 0 && $(this).val().indexOf("@emerson.edu") == -1
				$(this).parent().append('<span class="form_error_desc">Please use an Emerson email address.</span>')
				anyErrors = true
		return false if anyErrors

	$('#date').pickadate({
		format: 'mmm d, yyyy',
		formatSubmit: 'yyyy-mm-dd'
	})
	$('#time_start, #time_end').pickatime({
		formatSubmit: 'HH:i'
	})
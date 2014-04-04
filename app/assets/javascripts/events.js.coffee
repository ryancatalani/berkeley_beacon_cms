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
			return if $(this).attr('id') in ['event_image', 'event_link', 'event_tickets']
			return if $(this).attr('name') in ['time_end[]_submit', 'time_end[]']
			$(this).removeClass('form_error')
			if $(this).val() == ''
				$(this).addClass('form_error')
				anyErrors = true
			if $(this).attr('id') == 'event_organizer_email' && $(this).val().length > 0 && $(this).val().indexOf("@emerson.edu") == -1
				$(this).parent().append('<span class="form_error_desc">Please use an Emerson email address.</span>')
				anyErrors = true
		return false if anyErrors

	if $('.date').length > 0
		$('.date').pickadate({
			format: 'mmm d, yyyy',
			formatSubmit: 'yyyy-mm-dd'
		})
		$('.time_start, .time_end').pickatime({
			formatSubmit: 'HH:i'
		})

	$('.event_description').each ->
		if $(this).height() > 300
			$(this).css('height', 300)
			$(this).parent().append('<p><a href="#" class="event_read_more"><em>Read more...</em></a><p>')

	$('.event_read_more').click (e) ->
		e.preventDefault()
		$(this).parents('.event_box').find('.event_description').css('height', 'auto')
		$(this).hide()
		return false

	$('#add_event_date').click (e) ->
		e.preventDefault()
		fields = '<div class="event_date_fields">
				<input class="date" name="date[]" placeholder="When is it?" type="text" value="" /> <br>
				<input class="time_start" name="time_start[]" placeholder="Start time" type="text" value="" />
				<div style="float:left;margin:0 5%">to</div>
				<input class="time_end" name="time_end[]" placeholder="End time (optional)" type="text" value="" />
				</div>'
		$('.event_date_fields').last().after(fields)
		$('.date').pickadate({
			format: 'mmm d, yyyy',
			formatSubmit: 'yyyy-mm-dd'
		})
		$('.time_start, .time_end').pickatime({
			formatSubmit: 'HH:i'
		})
		return false

	$('#events_submit').click (e) ->
		e.preventDefault()
		$('#new_event_inline').slideDown()
		return false
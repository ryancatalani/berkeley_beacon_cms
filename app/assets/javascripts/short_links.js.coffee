# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->

	# Based on http://stackoverflow.com/questions/8851721/rails-3-displaying-errors-when-data-remote-is-true
	handle_ajax_error = (response) ->
		try
			responseJSON = jQuery.parseJSON(response)
		catch e
			responseJSON = null
		if responseJSON
			responseMsg = responseJSON.error
		else
			responseMsg = 'There was an unknown error or the request timed out.  Please try again later.'

		return responseMsg

	$("#new_short_link").on('ajax:success', (event, data, status, xhr) ->
		$('#new_short_link_success').fadeIn()
		new_row = """
				<tr>
					<td>#{ data.full_path }</td>
					<td>#{ data.destination }</td>
					<td>Refresh page to delete</td>
				</tr>
				"""
		$('#short_links_table').append(new_row)
	)
	.on('ajax:error', (event, xhr, status)->
		$('#new_short_link_error').find('.alert_text').text(handle_ajax_error(xhr.responseText))
		$('#new_short_link_error').fadeIn()
	)

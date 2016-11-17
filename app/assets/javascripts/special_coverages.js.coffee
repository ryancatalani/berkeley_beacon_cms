# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$('#clear_post').click ->
		$('#sc_new_update').clearForm()
		$('#update_body').html('')

	$('#sc_new_update').submit ->
		$(this).find('.spinner').fadeIn()
		$(this).find('.btn-primary').prop('disabled', true)

	# $(".sc_uploaded_files").sortable update: (event, ui) ->
	# 	ids = $(this).find('img').map ->
	# 		return parseInt this.id
	# 	$("#media_ids").val(ids.get().join())

	$('.special_coverage_form').find('select').chosen()
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$("#social_post_status_text").keyup ->
		v = $(this).val()
		l = v.length
		$("#text_length").html l
		$("#post_preview").html v
		$(this).addClass('post_text_warning') if l >= 100
		$(this).addClass('post_text_over') if l >= 119
		$(this).removeClass('post_text_warning post_text_over') if l < 100
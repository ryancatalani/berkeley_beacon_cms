# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	# media_img = $("#media").find("img")
	# h = ((media_img.height() - 546) / 2) * -1
	# old_height = media_img.height()
	# x_mov = "-" + h + "px"
	# media_img.css("marginTop",parseFloat(h))
	
	$("#sidebar").hover ->
		$(this).fadeTo('fast',1)
	,->
		$(this).fadeTo('fast',0.5)
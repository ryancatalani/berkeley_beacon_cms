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
	$("#media").hover ->
		$("#gallery_back_btn").fadeIn()
		$("#gallery_forward_btn").fadeIn()		
	,->
		$("#gallery_back_btn").fadeOut()
		$("#gallery_forward_btn").fadeOut()		
	containers = $("#media").find(".media_container")
	i = 0
	$("#gallery_back_btn").click ->
		$(containers.eq(i)).fadeOut().hide()
		i--
		i = 0 if i < 0
		$(containers.eq(i)).fadeIn()
	$("#gallery_forward_btn").click ->
		$(containers.eq(i)).fadeOut().hide()
		i++
		i = 0 if i == containers.size()
		$(containers.eq(i)).fadeIn()
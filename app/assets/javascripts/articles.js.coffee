# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$("#sections").click ->
		if $(".show_section").eq(0).css('display') == 'none' then $(".show_section").show() else $(".show_section").hide()


	$("div[rel=popover]").popover()
	$("div[rel=tooltip]").tooltip()
	$("a[rel=tooltip]").tooltip()	
	# media_img = $("#media").find("img")
	# h = ((media_img.height() - 546) / 2) * -1
	# old_height = media_img.height()
	# x_mov = "-" + h + "px"
	# media_img.css("marginTop",parseFloat(h))
	
	$("#author_1").change ->
		$("#author_headsup").slideUp()

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
	$("#funny_business").click ->
		$.post("/archive_problem/" + encodeURIComponent($(".article_wrap").find("h1").text()))
		$(this).html("Thanks for the tip!")
$(window).bind "load", ->
	if $(".big_photo").length > 0
		$("img.big_photo").each (x) ->
			console.log "width:" + $(this).width()
			ml = (820 - $(this).width()) / 2
			$(this).css('marginLeft', ml)
			$(mediafile_loading).fadeOut('fast').hide()
			$(this).fadeIn('fast')
		$("#gallery_wrap").height($(".big_photo").eq(0).height()+20)
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	if $(".balance_height")
		max = 0
		$(".balance_height").each ->
			max = $(this).height() if ($(this).height() > max) 
		$(".balance_height").each ->
			$(this).css("height",max)


	# $(".video_page_video").each ->
	# 	width = $(this).width()
	# 	height = Math.round(width * 9 / 16)
	# 	$(this).css height: height
	# 	console.log height

	$("#search_btn").click ->
		$("#search_box_wrap").fadeToggle()

	w = $("#latest_videos_inner").width()
	$("#latest_videos_container").css width: w
	$(".latest_video").each -> 
		$(this).css width: w
	$("#latest_videos_inner").css width: w * 3

	$("#latest_video_position").css marginLeft: (w/6)-10

	$(".latest_video_thumb").click (e) ->
		e.preventDefault()
		vid_i = $(this).data("video")
		offset = vid_i * w * -1
		pos_offset = ((vid_i*2)+1) * (w/6) - 10
		$("#latest_videos_inner").animate
			marginLeft: offset
			300
		$("#latest_video_position").animate
			marginLeft: pos_offset
			300
		return false
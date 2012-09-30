# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	$("#search_btn").click ->
		$("#search_box_wrap").fadeToggle()

	w = $("#latest_videos_inner").width()
	$("#latest_videos_container").css width: w
	$(".latest_video").each -> 
		$(this).css width: w
	$("#latest_videos_inner").css width: w * 3

	initial = (w/6)-10
	$("#latest_video_position").css marginLeft: initial
	console.log initial

	$(".latest_video_thumb").click ->
		vid_i = $(this).data("video")
		offset = vid_i * w * -1
		pos_offset = ((vid_i*2)+1) * (w/6) - 10
		console.log offset
		console.log pos_offset
		$("#latest_videos_inner").animate
			marginLeft: offset
			300
		$("#latest_video_position").animate
			marginLeft: pos_offset
			300
		# v_id = $(this).data("video")
		# pos = $(".latest_video[data-video='#{v_id}']").offset();
		# console.log pos
	# console.log new_width
	# $("#latest_videos_inner").css width: new_width
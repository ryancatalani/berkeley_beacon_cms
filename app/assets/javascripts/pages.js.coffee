# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	if $(".balance_height")
		setTimeout ->
			max = 0
			$(".balance_height").each ->
				max = $(this).height() if ($(this).height() > max)
			$(".balance_height").each ->
				$(this).css("height",max)
		, 500

	if $(".balance_height_nophone") && $(window).width() > 640
		setTimeout ->
			maxes = {}
			$(".balance_height_nophone").each ->
				group = $(this).data('height-group')
				height = $(this).height()
				if maxes[group]
					maxes[group] = height if height > maxes[group]
				else
					maxes[group] = height
			$(".balance_height_nophone").each ->
				group = $(this).data('height-group')
				$(this).css("height",maxes[group])
		, 500

	$("#popular_most_viewed_h").click (e) ->
		$("#popular_most_shared").hide()
		$("#popular_most_viewed").show()
		$("#popular_separator, #popular_inactive_separator").css("float", "left")
		$(this).addClass("active").removeClass("inactive")
		$("#popular_most_shared_h").removeClass("active").addClass("inactive")
		e.preventDefault()
		return false

	$("#popular_most_shared_h").click (e) ->
		$("#popular_most_viewed").hide()
		$("#popular_most_shared").show()
		$("#popular_separator, #popular_inactive_separator").css("float", "right")
		$(this).addClass("active").removeClass("inactive")
		$("#popular_most_viewed_h").removeClass("active").addClass("inactive")
		e.preventDefault()
		return false

	if $(".search_mediafile")
		old_height = 0
		$(".search_mediafile_caption").each ->
			h = ($(this).height() + 14) * -1
			$(this).css("marginBottom", h)
		$(".search_mediafile").hover ->
			old_height = $(this).find(".search_mediafile_caption").css("marginBottom")
			$(this).find(".search_mediafile_caption").animate({"marginBottom": 0}, 250)
		, ->
			$(this).find(".search_mediafile_caption").animate({"marginBottom": old_height}, 250)


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

	# if $('#emersonla')
	# 	(poll = ->
	# 	  $.ajax
	# 	    url: "/api/emersonla/updates"
	# 	    success: (data) ->

	# 	      #Update your dashboard gauge
	# 	      salesGauge.setValue data.value

	# 	    dataType: "json"
	# 	    complete: poll
	# 	    timeout: 30000

	# 	)()
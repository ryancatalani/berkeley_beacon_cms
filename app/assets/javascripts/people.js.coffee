# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	profileVideoBG = ->
		$('body.article_body').videoBG({
			position:"fixed",
			zIndex:0,
			mp4:'http://s3.amazonaws.com/RCPersonal/gauge/bkgd.mp4',
			ogv:'http://s3.amazonaws.com/RCPersonal/gauge/bkgd.ogv',
			webm:'http://s3.amazonaws.com/RCPersonal/gauge/bkgd.mp4',
			poster:'http://s3.amazonaws.com/RCPersonal/gauge/bkgd.png',
			opacity:1,
			fullscreen:true,
		});

	$(".person_editor").change ->
		$parent = $(this).parents('form')
		$parent.find(".show_if_editor").fadeToggle()
		should_check_staff = $(this).prop('checked')
		$parent.find(".person_staff").prop("checked", should_check_staff)

	if $(".person_editor").prop("checked")
		$parent = $(this).parents('form')
		$parent.find(".show_if_editor").show()
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
	total_h = $(window).height()
	h = total_h - 200
	$('#home_layout_panel_left').height(h)
	$('#home_layout_panel_right').height(h)

	lead_article_id = -1
	featured_article_ids = []
	middle_article_ids = []

	check_duplicate = (id) ->
		if (lead_article_id == id) or (featured_article_ids.indexOf(id) != -1) or (middle_article_ids.indexOf(id) != -1)
			return true
		return false

	set_lead = (element) ->
		title = element.find('.article_title').text()
		id = element.attr('data-article-id')
		$('input#lead').val(id)
		$('#home_layout_lead').find('.article_head').text(title)

	featured_id = 0
	set_featured = (element, position) ->
		title = element.find('.article_title').text()
		id = element.attr('data-article-id')
		pos = featured_id
		pos = position if position?
		$('input#featured_' + pos).val(id)
		$('#home_layout_featured_' + pos).find('.article_head').text(title)
		if featured_id == 2 or position?
			featured_id = 0
		else
			featured_id++

	middle_id = 0
	set_middle = (element, position) ->
		title = element.find('.article_title').text()
		id = element.attr('data-article-id')
		pos = middle_id
		pos = position if position?
		$('input#middle_' + pos).val(id)
		$('#home_layout_middle_' + pos).find('.article_head').text(title)
		if middle_id == 4 or position?
			middle_id = 0
		else
			middle_id++

	$(".set_lead").click ->
		article = $(this).parent()
		set_lead(article)

	$('.set_featured').click ->
		article = $(this).parent()
		set_featured(article)

	$('.set_middle').click ->
		article = $(this).parent()
		set_middle(article)

	$('.should_use_photo').change ->
		val = $(this).prop('checked')
		id = $(this).parent().attr('id').replace('home_layout_','').concat('_should_use_photo')
		$("input##{id}").val(val)

	try
		$('.home_layout_article').draggable({
			helper: 'clone'
		})
		$('.article_placer').droppable({
			hoverClass: 'article_placer_hover'
			drop: (event, ui) ->
				if $(this).hasClass('lead')
					set_lead(ui.draggable)
				else if $(this).hasClass('featured')
					position = parseInt($(this).attr('data-position'))
					set_featured(ui.draggable, position)
				else if $(this).hasClass('middle')
					position = parseInt($(this).attr('data-position'))
					set_middle(ui.draggable, position)
		})

	catch error

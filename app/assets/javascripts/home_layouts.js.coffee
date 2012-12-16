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

	$(".set_lead").click ->
		article = $(this).parent()
		title = article.find('.article_title').text()
		id = article.attr('data-article-id')
		$('input#lead').val(id)
		$('#home_layout_lead').text(title)

	featured_id = 0

	$('.set_featured').click ->
		article = $(this).parent()
		title = article.find('.article_title').text()
		id = article.attr('data-article-id')
		$('input#featured_' + featured_id).val(id)
		$('#home_layout_featured_' + featured_id).text(title)
		if featured_id == 2
			featured_id = 0
		else
			featured_id++

	middle_id = 0

	$('.set_middle').click ->
		article = $(this).parent()
		title = article.find('.article_title').text()
		id = article.attr('data-article-id')
		$('input#middle_' + middle_id).val(id)
		$('#home_layout_middle_' + middle_id).text(title)
		if middle_id == 4
			middle_id = 0
		else
			middle_id++

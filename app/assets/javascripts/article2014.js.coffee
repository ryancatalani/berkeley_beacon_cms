jQuery ->
	pop_width = 0
	if $('body.a14_article').find('#popular_inner').length > 0
		popular_inner = $('#popular_inner')
		pop_width = popular_inner.width()
		$('.popular').css(
			width: pop_width,
			overflow: 'hidden'
		)
		popular_inner.find('.popular_type').each ->
			$(this).css(
				width: pop_width,
				float: 'left'
			)
		popular_inner.css('width', pop_width * 2)
		# Don't use hide() since that changes visibility and messes up position.
		$('#popular_shared').css('opacity', 0)

	on_pop_viewed = true
	$('.popular_switch').find('a').click (e) ->
		e.preventDefault()
		show = $(this).data('idref')
		unshow = if on_pop_viewed then 'popular_viewed' else 'popular_shared'
		return false if (on_pop_viewed and show == 'popular_viewed') or (!on_pop_viewed and show == 'popular_shared')
		animateVal = if on_pop_viewed then -1 * pop_width else 0
		animateTime = 350
		$('#popular_inner').animate(
			marginLeft: animateVal
		, animateTime)
		# Don't use fadeIn/Out since that changes visibility and messes up position.
		$("##{show}").animate(
			opacity: 1
		, animateTime)
		$("##{unshow}").animate(
			opacity: 0
		, animateTime)
		$(this).addClass('active')
		$(this).siblings().first().removeClass('active')
		on_pop_viewed = !on_pop_viewed
		return false

	$('.fb_slide').hide()
	$('#article_fb_share_btn').hover ->
		$('.fb_slide').show()
		$(this).find('.fb_slide').animate(
			width: 110,
			opacity: 1
		, 100)
	, ->
		$(this).find('.fb_slide').animate(
			width: 0,
			opacity: 0
		, 100)

	$('.article_share').find('a').click (e) ->
		e.preventDefault()
		window.open(
			$(this).prop('href'),
			'Share',
			'width=600,height=200,resizable'
		)
		return false

	$('.rslides_a14').responsiveSlides(
		auto: false,
		nav: true,
		prevText: '<i class="fa fa-chevron-circle-left fa-3x"></i>',
		nextText: '<i class="fa fa-chevron-circle-right fa-3x"></i>',
		controls: '.gallery_nav_container',
	)

	gallery_show = ->
		$('body').addClass('prevent_scroll')
		$('body').bind 'touchmove', (e) ->
			e.preventDefault()
		scrollPos = $('body').scrollTop()
		$('.gallery_full').css(
			top: scrollPos,
			bottom: -1 * scrollPos
		)
		$('.gallery_full').fadeIn()
	gallery_hide = ->
		$('body').removeClass('prevent_scroll')
		$('body').unbind 'touchmove'
		$('.gallery_full').fadeOut()
	$('.gallery_open').click ->
		gallery_show()
	$('.gallery_close').click ->
		gallery_hide()


	if window.location.search.indexOf('?a14=true') != -1
		$('a').each ->
			return true if $(this).prop('href').substr('#') == -1
			$(this).prop('href', $(this).prop('href') + '?a14=true')
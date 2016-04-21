jQuery ->
	$.getJSON '/api/pop_data', (data) ->
		viewed_data = data.viewed
		shared_data = data.shared

		pv_pf = $('#popular_viewed').find('.popular_first')
		pv_pf.attr('href', viewed_data[0].url)
		if viewed_data[0].thumb_220
			$('<img>').attr(src: viewed_data[0].thumb_220).appendTo pv_pf
		pv_pf.append("1. #{ viewed_data[0].title }")

		pv_ol = $('#popular_viewed').find('ol')
		for i in [1..4]
			a = viewed_data[i]
			if a.thumb_40
				li = "<li>
					<a href='#{ a.url }'>
						<img src='#{a.thumb_40}'>
						#{ a.title }
					</a>
					</li>"
			else
				li = "<li>
					<a href='#{ a.url }'>#{ a.title }</a>
					</li>"
			pv_ol.append(li)

		ps_pf = $('#popular_shared').find('.popular_first')
		ps_pf.attr('href', shared_data[0].url)
		ps_pf_shares = parseInt(shared_data[0].shares)

		if ps_pf_shares > 1000
			ps_pf_shares = Math.trunc(ps_pf_shares / 100) / 10 + 'K'

		if shared_data[0].thumb_220
			$('<img>').attr(src: shared_data[0].thumb_220).appendTo ps_pf
		ps_pf.append("<div>
				<span class='share_count'>#{ ps_pf_shares }</span>
				1. #{ shared_data[0].title }
			</div>")

		ps_ol = $('#popular_shared').find('ol')
		for i in [1..4]
			a = shared_data[i]
			shares = parseInt(a.shares)

			if shares > 1000
				shares = Math.trunc(shares / 100) / 10 + 'K'

			li = "<li>
				<a href='#{ a.url }'>
					<span class='share_count'>#{ shares }</span>
					#{ a.title }
				</a>
			</li>"
			ps_ol.append(li)

		$('#popular2014').show 0, ->
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


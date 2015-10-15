jQuery ->

	$('.sidebar').each ->
		if $(this).data('type') == 'series' or $(this).data('type') == 'topics'
			sidebar = $(this)
			type = sidebar.data('type')
			slug = sidebar.data('slug')
			api_url = "/api/#{ type }/#{ slug }"
			$.getJSON api_url, (data) ->
				ul = sidebar.find('ul')
				for i in [0..data.length-1]
					a = data[i]
					if a.thumb_40
						li = "<li>
							<a href='#{ a.url }'>
								<img src='#{ a.thumb_40 }' />
								<span class='sidebar_topic_article_date'>#{ a.date }</span>
								#{ a.title }
							</a>
						</li>"
					else
						li = "<li>
							<a href='#{ a.url }'>
								<span class='sidebar_topic_article_date'>#{ a.date }</span>
								#{ a.title }
							</a>
						</li>"
					ul.append(li)
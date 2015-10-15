jQuery ->

	$('.sidebar').each ->
		sidebar = $(this)
		type = sidebar.data('type')
		if type == 'series' or type == 'topics' or type == 'sections'
			slug = sidebar.data('slug')
			api_url = "/api/#{ type }/#{ slug }"
			$.getJSON api_url, (data) ->
				if data.length > 0 
					ul = sidebar.find('ul')
					for i in [0..data.length-1]
						a = data[i]

						continue if $('#article_ident').data('article-ident') == a.id

						li = "<li><a href='#{ a.url }'>"
						if a.thumb_40
							li += "<img src='#{ a.thumb_40 }' />"
						if type == 'series' or type == 'topics'
							li += "<span class='sidebar_topic_article_date'>#{ a.date }</span> "
						li += "#{ a.title }</a></li>"

						ul.append(li)
						
					sidebar.fadeIn('fast')
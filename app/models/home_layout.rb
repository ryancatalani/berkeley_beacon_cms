class HomeLayout < ActiveRecord::Base
	attr_accessible :layout_type, :articles, :breaking_text, :breaking_article, :custom_top_html
	serialize :articles

	# layout_type DEFAULT = 1

	# articles = {}
	# articles[:lead] = INTEGER
	# articles[:featured] = [ ... ]
	# articles[:middle] = [ ... ]

end

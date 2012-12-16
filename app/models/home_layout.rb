class HomeLayout < ActiveRecord::Base
	attr_accessible :layout_type, :articles, :breaking_text, :breaking_article, :custom_top_html
	serialize :articles

end

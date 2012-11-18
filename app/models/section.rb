class Section < ActiveRecord::Base
	has_many :articles

	def non_blog_articles
		self.articles.where(:blog_id => [false, nil], :draft => [false, nil])
	end

	def self.home_cache_key(section_name)
		self.find_by_name(section_name.capitalize).non_blog_articles.maximum(:updated_at).to_i
	end

end
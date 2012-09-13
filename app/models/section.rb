class Section < ActiveRecord::Base
	has_many :articles

	def non_blog_articles
		self.articles.where(:blog_id => [0, nil], :draft => [0, nil])
	end

end
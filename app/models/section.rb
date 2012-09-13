class Section < ActiveRecord::Base
	has_many :articles

	def non_blog_articles
		self.articles.where(:blog_id => [false, nil], :draft => [false, nil])
	end

end
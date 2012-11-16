class PopularSnapshot < ActiveRecord::Base
	# most_viewed: [:article_id, INTEGER (views)]
	# most_shared: [:article_id, INTEGER (shares)]

	attr_accessible :most_viewed, :most_shared
	serialize :most_viewed
	serialize :most_shared

	def self.latest_most_viewed
		last.most_viewed.map {|a| Article.find(a[0]) }
	end

	def self.latest_most_shared
		last.most_shared.map {|a| [Article.find(a[0]), a[1]] }
	end

end

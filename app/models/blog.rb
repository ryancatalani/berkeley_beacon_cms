class Blog < ActiveRecord::Base
	has_many :articles

	def to_url
		"/blogs/#{cleantitle}"
	end
end

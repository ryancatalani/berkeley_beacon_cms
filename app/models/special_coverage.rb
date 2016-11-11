class SpecialCoverage < ActiveRecord::Base
	serialize :featured
	serialize :related_articles
	serialize :media
	serialize :updates

	def slug
		title.downcase.strip.gsub(/\W/,'_').gsub(/_{2,}/,'_')
	end

	def to_url
		"/special/#{id}/#{slug}"
	end

	def to_full_url
		"http://www.berkeleybeacon.com#{to_url}"
	end
end

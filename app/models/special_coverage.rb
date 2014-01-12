class SpecialCoverage < ActiveRecord::Base
	serialize :featured
	serialize :related_articles
	serialize :media
	serialize :updates
end

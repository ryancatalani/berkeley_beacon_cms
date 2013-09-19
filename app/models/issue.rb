class Issue < ActiveRecord::Base
	validates_presence_of :release_date
	attr_accessible :release_date, :pdf_url, :pdf_thumb_url
	has_many :articles

	def release_date_f
		release_date.to_formatted_s(:long)
	end

	def path
		"issues/#{release_date}"
	end
end

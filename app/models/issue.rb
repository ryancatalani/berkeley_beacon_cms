class Issue < ActiveRecord::Base
	validates_presence_of :release_date
	attr_accessible :release_date, :pdf_url, :pdf_thumb_url
	serialize :section_shares
	has_many :articles

	def release_date_f
		release_date.to_formatted_s(:long)
	end

	def path
		"/issues/view/#{release_date}"
	end

	def released_yet?
		Date.today >= release_date
	end

	def ok_to_display?
		released_yet? && pdf_url? && pdf_thumb_url?
	end

	def self.latest(n=1)
		if n == 1
			possible = Issue.last(2)
			if possible.last.released_yet?
				return possible.last
			else
				return possible.first
			end
		else # n > 1
			possible = Issue.last(n+1)
			if possible.last.released_yet?
				return possible.last(n)
			else
				return possible.first(n)
			end
		end
	end
end

class Issue < ActiveRecord::Base
	validates_presence_of :release_date
	serialize :section_shares
	has_many :articles
	has_many :editorial_cartoons

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

	def self.ok_to_display
		self.where('release_date <= ?', Date.today).where.not(pdf_url: nil, pdf_thumb_url: nil)
	end

	def social_shares_by_section(name)
		section = Section.find_by_name(name.capitalize)
		if section
			section_articles = articles.where(section_id: section.id)
			return section_articles.map(&:total_social_shares).sum
		end
	end

	def social_quotient_by_section(name)
		section = Section.find_by_name(name.capitalize)
		if section
			section_articles = articles.where(section_id: section.id)
			return 0 if section_articles.count == 0
			return (section_articles.map(&:total_social_shares).sum / section_articles.count.to_f).round(1).to_s
		end
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

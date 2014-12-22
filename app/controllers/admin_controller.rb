class AdminController < ApplicationController
	before_filter :check_editor

	def home
	end

	def poll_results
		@entries = PoliticalPollEntry.all
		@error = (1 / Math.sqrt(@entries.count) * 100).round(2)
	end

	def published_in_date_range
		# acceptable formats: 2014-spring, 2014-fall, 2014-spring,fall
		# TEST dates = ["2014-spring,fall"]
		dates = params[:dates].split(';')
		@date_range = params[:dates].gsub('-',' ').gsub(/([;,])/) { "#{$&} " }

		@articles = []
		@mediafiles = []

		dates.each do |date|
			year = date.first(4)
			month_start = date.include?("spring") ? 1 : 6
			month_end = date.include?("fall") ? 12 : 5
			date_start = Date.parse("#{year}-#{month_start}-01")
			date_end = Date.parse("#{year}-#{month_end}-31")

			@articles << Article.where(draft: false, created_at: date_start..date_end)
			@mediafiles << Mediafile.joins(:articles).where(articles: {draft: false, created_at: date_start..date_end})
		end

		@articles.flatten!.sort_by! {|a| a.created_at }
		@mediafiles.flatten!.sort_by! {|m| m.created_at }
		
	end

end

class AdminController < ApplicationController
	before_filter :check_editor

	def home
	end

	def poll_results
		@entries = PoliticalPollEntry.all
		@error = (1 / Math.sqrt(@entries.count) * 100).round(2)
	end

end

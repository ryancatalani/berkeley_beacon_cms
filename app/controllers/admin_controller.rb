class AdminController < ApplicationController
	before_filter :check_editor
	
	def home
	end

	def poll_results
		@entries = PoliticalPollEntry.all
	end
		
end

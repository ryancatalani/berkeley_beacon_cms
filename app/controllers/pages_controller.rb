class PagesController < ApplicationController
	def home
		@current_user = current_user
	end

	def about
	end

end

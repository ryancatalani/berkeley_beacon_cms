class SectionsController < ApplicationController
	# before_filter :gohome
	
	def show
		begin
			section = Section.find_by_clean_url params[:name]
			@sname = section.name
			@articles = section.articles.order("created_at DESC")
		rescue
			redirect_to root_path
		end
	end
	
	private
		def gohome
			redirect_to root_path
		end

end

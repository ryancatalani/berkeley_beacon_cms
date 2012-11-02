class SectionsController < ApplicationController
	# before_filter :gohome
	caches_action :show

	def show
		@include_responsive = true
		begin
			section = Section.find_by_clean_url params[:name]
			@sname = section.name
			@articles = section.articles.paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
		rescue
			redirect_to root_path
		end
	end
	
	private
		def gohome
			redirect_to root_path
		end

end

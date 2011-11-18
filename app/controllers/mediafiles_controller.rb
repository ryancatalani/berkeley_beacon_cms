class MediafilesController < ApplicationController
	
	# respond_to :html, :js

	def index
	end

	def new
		@mediafile = Mediafile.new
	end
	
	def create
		p = params[:mediafile]
		p[:mediatype] = params[:mediatype].to_i
		@mediafile = Mediafile.new(p)
		if @mediafile.save
			# respond_with @mediafile, :location => mediafiles_url
			# respond_to do |format|
		else
			render 'new'
		end
	end

end

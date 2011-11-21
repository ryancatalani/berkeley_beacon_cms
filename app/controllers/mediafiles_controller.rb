class MediafilesController < ApplicationController
	
	respond_to :html, :js

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
			respond_with @mediafile, :location => mediafiles_url
			# # format.html { redirect_to mediafiles_path }
			# format.js
		else
			# respond_with
			# format.html { render :action => 'new' }
			# format.js
		end
	end

end

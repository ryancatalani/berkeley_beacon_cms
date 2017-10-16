class ShortLinksController < ApplicationController

	before_filter :check_editor
	respond_to :html, :js

	def index
		@links = ShortLink.all
	end

	def create
		@short_link = ShortLink.new(short_link_params)
		if @short_link.save
			render :json => { :full_path => @short_link.full_path, :destination => @short_link.destination, :id => @short_link.id }
		else
			render :json => {:error => @short_link.errors.full_messages.to_sentence},
			:status => :unprocessable_entity
       end
	end

	def update
	end

	def destroy
		@short_link = ShortLink.find(params[:id]).destroy
		respond_with @short_link
	end

	def redirect
		# Ignoring prefix for now; assuming it's 'berkeleybeacon.com/go/'
		short_link = ShortLink.find_by_link_text(params[:slug])
		redirect_to short_link.destination and return
	end

	private

	def short_link_params
		params.require(:short_link).permit(:prefix, :link_text, :destination)
	end

end

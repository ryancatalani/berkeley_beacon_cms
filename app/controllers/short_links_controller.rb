class ShortLinksController < ApplicationController

	before_filter :check_editor
	respond_to :html, :js

	def index
		@links = ShortLink.all
	end

	def create
		@short_link = ShortLink.new(params[:short_link])
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

end

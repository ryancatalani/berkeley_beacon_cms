class CustomPagesController < ApplicationController

	before_filter :check_editor, except: :apply

	def index
		@pages = CustomPage.all
	end

	def new
	end

	def create
	end

	def edit
		@page = CustomPage.find(params[:id])
	end

	def update
		@page = CustomPage.find(params[:id])
		p = params[:custom_page]
		if @page.update_attributes(p)
			redirect_to people_path
		else
			render 'edit'
		end
	end

	def show
		page = CustomPage.find_by_slug(:slug)
		@title = page.title
	end

	def apply
		apply_page = CustomPage.find_by_slug("apply")
		@title = apply_page.title
		@content = apply_page.content

		@title = "Join the Beacon"
		@new_header = true
		@needs_og = true
		@og ||= {}
		@og[:title] = "Join the Beacon"
		@og[:image] = "http://berkeleybeacon.com/assets/apply_small.jpg"
		@og[:description] = "What's your beat? Find it with the Beacon. Applications for staff positions are due on Friday, April 19."
		@applications_open = true
		render :show, layout: 'new_header'
	end

end
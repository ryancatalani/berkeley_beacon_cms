class EditorialCartoonsController < ApplicationController

	before_filter :check_editor, except: [:index]

	def index
		@cartoons = EditorialCartoon.cartoons
		if @cartoons.count == 0
			s = Series.find_by_title("Editorial Cartoons")
			redirect_to root_path and return if s.nil?
			@include_responsive = true
			@cartoons = s.mediafiles.order("created_at DESC")
		end
	end

	def edit_index
		@cartoons = EditorialCartoon.order("created_at DESC")
		if @cartoons.count == 0
			s = Series.find_by_title("Editorial Cartoons")
			redirect_to root_path and return if s.nil?
			@include_responsive = true
			@cartoons = s.mediafiles.order("created_at DESC")
		end
	end

	def new
		@authors = Person.order("firstname ASC").all.map { |person| [person.official_name, person.id] }
		@mediafile = Mediafile.new
	end

	def edit
		@cartoon = EditorialCartoon.find(params[:id])
		@issue = @cartoon.issue
		@authors = Person.order("firstname ASC").all.map { |person| [person.official_name, person.id] }
		@mediafile = @cartoon.mediafile
	end

	def destroy
		cartoon = EditorialCartoon.find(params[:id])
		cartoon.mediafile.destroy
		cartoon.destroy
		redirect_to admin_editorial_cartoons_path
	end

	private

	def editorial_cartoon_params
		params.require(:editorial_cartoon).permit(:issue_id, :slug, :issue_date)
	end

end

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
		@cartoons = EditorialCartoon.cartoons
		if @cartoons.count == 0
			s = Series.find_by_title("Editorial Cartoons")
			redirect_to root_path and return if s.nil?
			@include_responsive = true
			@cartoons = s.mediafiles.order("created_at DESC")
		end
	end

end

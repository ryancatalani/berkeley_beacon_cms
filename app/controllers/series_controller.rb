class SeriesController < ApplicationController
	before_filter :check_editor
	
	def index
		@series = Series.all
	end
	
  def new
		@series = Series.new
  end

  def create
		@series = Series.new(params[:series])
		if @series.save
			redirect_to articles_path
		else
			render 'new'
		end
  end

  def edit
		@series = Series.find(params[:id])
  end

  def update
		@series = Series.find(params[:id])
		if @series.update_attributes(params[:series])
			redirect_to articles_path
		else
			render 'new'
		end
  end

end

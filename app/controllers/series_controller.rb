class SeriesController < ApplicationController
	before_filter :check_editor, except: [:show]
	
	def index
		@series = Series.all
	end
	
  def new
		@series = Series.new
  end

  def create
		@series = Series.new(params[:series])
		@series.slug = @series.title.downcase.gsub(' ','_').gsub(/\W/,'')
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

  def show
  	@include_responsive = true
  	begin
  	  series = Series.find_by_slug params[:slug]
  	  @sname = series.title
  	  @articles = series.articles.paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
  	  @show_series_name = true
  	  render "sections/show"
  	rescue
  	  redirect_to root_path
  	end
  end

end

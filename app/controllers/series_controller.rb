class SeriesController < ApplicationController
	before_filter :check_editor, except: [:show, :api_list_by_slug]
	
	def index
		@series = Series.all
	end
	
  def new
		@series = Series.new
  end

  def create
		@series = Series.new(series_params)
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
		if @series.update_attributes(series_params)
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

  def api_list_by_slug
  	begin
  		series = Series.find_by_slug params[:slug]
  		articles = series.articles.order('created_at DESC').first(5)
  		render json: api_wrangle_articles(articles)
  	rescue
  		render json: []
  	end
  end

  private

  def series_params
    params.require(:series).permit(:description, :logo, :title, :slug)
  end


end

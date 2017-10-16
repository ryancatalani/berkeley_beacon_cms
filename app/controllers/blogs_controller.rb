class BlogsController < ApplicationController
  def index
    @blogs = Blog.all
    @include_responsive = true
  end

  def new
    @blog = Blog.new
  end

  def create
    p = params[:blog]
    p[:cleantitle] = p[:title].strip.downcase.gsub(/[^A-z0-9\s]/,'').split(' ').first(8).join('-')
    @blog = Blog.new(p)
    if @blog.save
      redirect_to new_article_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def show
    @include_responsive = true
    begin
      @blog = Blog.find_by_cleantitle params[:name]
      @articles = @blog.articles.paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
    rescue
      redirect_to root_path
    end

  end

  def by_title
  end

end

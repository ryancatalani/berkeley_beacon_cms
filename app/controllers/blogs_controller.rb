class BlogsController < ApplicationController
  def index
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

  def by_title
  end

end

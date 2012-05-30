class BlogsController < ApplicationController
  def index
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.new(params[:blog])
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

end

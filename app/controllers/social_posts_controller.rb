class SocialPostsController < ApplicationController
  before_filter :check_editor

  def index
    @posts = SocialPost.order('post_time ASC')
  end

  def new
    if params[:a]
      begin
        article = Article.find(params[:a].to_i)
        text = article.title.truncate(119, :separator => ' ').strip
        text << " (by #{article.twitter_names})" unless article.twitter_names.blank?
        text << ':'
        @post = SocialPost.new(:status_text => text, :network => 1)
        @url = article.to_url(:full => true)
        @article_id = article.id
      rescue
        @post = SocialPost.new
      end
    else
      @post = SocialPost.new
    end
    @char_init = article.nil? ? 0 : text.length
    @char_limit = 116
    @networks = SocialPost.networks
  end

  def create
    p = params[:social_post]
    p[:posted] = false
    article = Article.find(p[:article_id])
    @post = article.social_posts.build(params[:social_post])
    if @post.save
      redirect_to social_posts_path
    else
      @networks = SocialPost.networks
      render 'new'
    end
  end

  def edit
    @post = SocialPost.find(params[:id])
    @char_init = @post.status_text.length
    @char_limit = 119
    @networks = SocialPost.networks
    @url = @post.article.to_url(:full => true)
  end

  def update
    @post = SocialPost.find(params[:id])
    if @post.update_attributes(params[:social_post])
      redirect_to social_posts_path
    else
      render 'new'
    end
  end

  def destroy
    SocialPost.find(params[:id]).destroy
    redirect_to social_posts_path
  end

end

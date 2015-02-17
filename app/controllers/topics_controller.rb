class TopicsController < ApplicationController
  def show
    @include_responsive = true
    begin
      topic = Topic.find_by_slug params[:slug]
      @sname = topic.title
      @articles = topic.articles.paginate(:page => params[:page], :per_page => 15).order("created_at DESC")
      @show_sname = true
      render "sections/show"
    rescue
      redirect_to root_path
    end
  end

  def create
  	p = params[:topic]
  	@topic = Topic.new(p)
    @topic.slug = @topic.title.downcase.gsub(' ','-').gsub(/-\W/,'')
  	if @topic.save
  		respond_to do |f|
  			f.html { redirect_to articles_path, :notice => "Saved topic" }
  			f.js
  		end
  	else
  	end
  end

  def edit
  end

  def update
  end

end

class TopicsController < ApplicationController
  def show
  end

  def create
  	p = params[:topic]
  	@topic = Topic.new(p)
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

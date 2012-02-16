class TaggingsController < ApplicationController
	before_filter :check_editor
	
  def new_tagging
    Tagging.create!(:tag_id => params[:tag_id].to_i, :article_id => params[:article_id].to_i)
    redirect_to articles_path
  end
  
end

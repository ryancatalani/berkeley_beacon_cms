class HomeLayoutsController < ApplicationController
	before_filter :check_editor

  def new
  	@home_layout = HomeLayout.new
  end

  def create
  	@home_layout = HomeLayout.new(params[:home_layout])
  	if @home_layout.save
  		redirect_to articles_path
  	else
  		render 'new'
  	end
  end

end

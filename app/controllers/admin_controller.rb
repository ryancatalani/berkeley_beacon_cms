class AdminController < ApplicationController
	before_filter :check_editor
	
	def home
	end
	
	private
	
		def check_editor
			redirect_to root_path unless current_user and current_user.editor?
		end

end

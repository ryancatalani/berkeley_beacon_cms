class ApplicationController < ActionController::Base
	protect_from_forgery

	private

		def current_user
			@current_user ||= Person.find(session[:user_id]) if session[:user_id]
		end
		
		def check_editor
			redirect_to root_path unless current_user and current_user.editor?
		end
		
		helper_method :current_user, :check_editor
	
end

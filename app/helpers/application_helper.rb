module ApplicationHelper
	def editor_logged_in
		current_user and current_user.editor?
	end
	
end

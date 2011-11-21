class ApplicationController < ActionController::Base
	protect_from_forgery

	private

		def current_user
			@current_user ||= Person.find(session[:user_id]) if session[:user_id]
		end
		
		def check_editor
			redirect_to root_path unless current_user and current_user.editor?
		end
				
		def bylineify people
			return people.first.official_name if people.count == 1
			if people.count == 2
				ret = people.map {|p| p.official_name }.join(' and ')
			else
				last = people.pop
				ret = people.map {|p| p.official_name }.join(', ')
				ret << ', ' << last.official_name
			end
			return ret
		end
		
		def bylineify_short people
			return people.first.full_name if people.count == 1
			if people.count == 2
				ret = people.map {|p| p.full_name }.join(' and ')
			else
				last = people.pop
				ret = people.map {|p| p.full_name }.join(', ')
				ret << ', ' << last.full_name
			end
			return ret
			
		end
		
		helper_method :current_user, :check_editor, :bylineify, :bylineify_short
	
end

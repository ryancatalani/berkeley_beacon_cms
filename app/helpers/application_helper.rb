module ApplicationHelper
	# def editor_logged_in
	# 	current_user and current_user.editor?
	# end
	
	def current_twitter
		beacon = {
			:consumer_key => "***REMOVED***",
			:consumer_secret => "***REMOVED***",
			:oauth_token => "***REMOVED***",
			:oauth_token_secret => "***REMOVED***"
		}
		magicofpi_test = {
			:consumer_key => "***REMOVED***",
			:consumer_secret => "***REMOVED***",
			:oauth_token => "***REMOVED***",
			:oauth_token_secret => "***REMOVED***"
		}
		if Rails.env.production?
			return Twitter::Client.new(beacon)
		else
			return Twitter::Client.new(magicofpi_test)
		end
	end
end

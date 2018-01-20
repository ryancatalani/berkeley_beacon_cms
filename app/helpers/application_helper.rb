module ApplicationHelper
	# def editor_logged_in
	# 	current_user and current_user.editor?
	# end

	def current_twitter
		beacon = {
			:consumer_key => ENV['TWITTER_CONSUMER_KEY'],
			:consumer_secret => ENV['TWITTER_CONSUMER_SECRET'],
			:oauth_token => ENV['TWITTER_OAUTH_TOKEN'],
			:oauth_token_secret => ENV['TWITTER_OAUTH_SECRET']
		}
		test = {
			:consumer_key => ENV['TWITTER_TEST_CONSUMER_KEY'],
			:consumer_secret => ENV['TWITTER_TEST_CONSUMER_SECRET'],
			:oauth_token => ENV['TWITTER_TEST_OAUTH_TOKEN'],
			:oauth_token_secret => ENV['TWITTER_TEST_OAUTH_SECRET']
		}
		if Rails.env.production?
			return Twitter::Client.new(beacon)
		else
			return Twitter::Client.new(test)
		end
	end

	def print_release_day
		"Thursday"
	end

end

if ENV['APIGEE_TWITTER_API_ENDPOINT']
	endpoint = ENV['APIGEE_TWITTER_API_ENDPOINT']
else
	endpoint = "***REMOVED***"
end

if ENV['APIGEE_TWITTER_SEARCH_API_ENDPOINT']
	search_endpoint = ENV['APIGEE_TWITTER_SEARCH_API_ENDPOINT']
else
	search_endpoint = "***REMOVED***"
end

Twitter.configure do |config|
	config.consumer_key = "***REMOVED***"
	config.consumer_secret = "***REMOVED***"
  # config.endpoint = "http://" + endpoint
  # config.search_endpoint = "http://" + search_endpoint
end

# @@beacon_twitter = Twitter::Client.new(
# 	:consumer_key => "***REMOVED***",
# 	:consumer_secret => "***REMOVED***",
# 	:oauth_token => "***REMOVED***",
# 	:oauth_token_secret => "***REMOVED***"
# )
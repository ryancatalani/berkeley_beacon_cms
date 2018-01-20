if ENV['APIGEE_TWITTER_API_ENDPOINT']
	endpoint = ENV['APIGEE_TWITTER_API_ENDPOINT']
else
	endpoint = nil
end

if ENV['APIGEE_TWITTER_SEARCH_API_ENDPOINT']
	search_endpoint = ENV['APIGEE_TWITTER_SEARCH_API_ENDPOINT']
else
	search_endpoint = nil
end

Twitter.configure do |config|
	config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
	config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  # config.endpoint = "http://" + endpoint
  # config.search_endpoint = "http://" + search_endpoint
end
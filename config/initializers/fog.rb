Carrierwave.configure do |config|
	config.fog_credentials = {
		:provider				=> 'AWS',
		:aws_access_key			=> '***REMOVED***',
		:aws_secret_access_key	=> '***REMOVED***',
	}
	config.fog_directory = 'beacon_uploads'
	config.fog_public
end
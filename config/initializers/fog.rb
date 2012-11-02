CarrierWave.configure do |config|
	config.fog_credentials = {
		:provider				=> 'AWS',
		:aws_access_key_id		=> '***REMOVED***',
		:aws_secret_access_key	=> '***REMOVED***',
	}
	config.fog_directory = 'BerkeleyBeacon/beacon_uploads'
	config.fog_public = true
	# config.fog_attributes = {'Cache-Control'=>'max-age=31540000'}
end
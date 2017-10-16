CarrierWave.configure do |config|
  config.cache_dir = "#{Rails.root}/tmp/uploads"
  config.storage    = :aws
  
  # config.aws_bucket = ENV.fetch('S3_BUCKET_NAME')
  config.aws_bucket = 'BerkeleyBeacon/beacon_uploads'
  config.aws_bucket = 'BerkeleyBeacon'

  config.aws_acl    = 'public_read'
  # config.asset_host = 'http://example.com'
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

  config.aws_credentials = {
    # access_key_id:     ENV.fetch('AWS_ACCESS_KEY_ID'),
    # secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY')
    access_key_id: '***REMOVED***',
    secret_access_key: '***REMOVED***',
    region: 'us-east-1'
  }
end
source 'http://rubygems.org'

gem 'rails', '3.1.1'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.4'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'carrierwave'
gem "remotipart", "~> 1.0"
gem 'tinymce-rails'
gem "heroku"
gem "fog", "~> 1.7.0"
gem 'faker'
gem 'exception_notification'
gem 'nokogiri'
gem 'mini_magick'
# gem 'rmagick'
gem "twitter", "~> 4.2.0"
gem 'will_paginate', '~> 3.0'
gem 'geocoder'
gem 'fb_graph'
gem 'feedzirra'
gem 'newrelic_rpm'
gem 'swiftype'
gem 'memcachier'
gem 'dalli'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

group :development do
end

group :development, :test do
  gem 'quiet_assets'
  gem 'sqlite3'
  gem 'ruby-prof'
  gem 'bullet'
end

group :production do
  gem 'pg'
  gem 'thin'
end
require 'rubygems'
require 'mongo'

source 'http://rubygems.org'
source 'http://gemcutter.org'
gem 'rails', '3.0.7'
gem "mechanize"
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
gem 'eventmachine', "0.12.10"
#gem 'will_paginate',:git => 'http://github.com/mislav/will_paginate.git',:branch=>'rails3'
gem "will_paginate", "~> 3.0.pre2"
gem 'thin'
#gem 'unicorn'
gem "mongoid", "2.0.1"
gem "bson_ext", "~> 1.2"
gem 'memcache-client'

gem 'request-log-analyzer'
#gem 'dalli'
# Use unicorn as the web server
# Deploy with Capistrano
# gem 'capistrano'
# To use debugger
# gem 'ruby-debug'
# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'
# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
group :development do
  gem 'rails-dev-boost', :git => 'git://github.com/thedarkone/rails-dev-boost.git', :require => 'rails_development_boost'
end
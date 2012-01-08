source "http://rubygems.org"

gem "haml"
gem "dalli"
gem "excon"
gem "redis"
gem "mysql2"
gem "airbrake"
gem "capistrano"
gem "jquery-rails"
gem "rails", "3.1.3"
gem "foreman", :require => false
gem "resque", :require => ["resque", "resque/server"]
gem "shinobi", :git => "git://github.com/saarons/shinobi.git"

group :production do
  gem "unicorn"
end

group :assets do
  gem "uglifier", ">= 1.0.3"
  gem "sass-rails", "~> 3.1.4"
  gem "coffee-rails", "~> 3.1.1"
end
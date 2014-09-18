source "http://rubygems.org"

gem "gon", "5.0.4"
gem "thin"
gem "mina"
gem "haml"
gem "dalli"
gem "excon"
gem "redis"
gem "execjs"
gem "mysql2"
gem "pusher"
gem "foreman"
gem "jquery-rails"
gem "rails", "3.2.17"
gem "nokogiri", "~> 1.5.10"
gem "bootstrap-sass", "~> 3.1.1"
gem "rufus-scheduler", "~> 2.0.24"
gem "daemon-spawn", :require => "daemon_spawn"
gem "shinobi", :git => "git://github.com/saarons/shinobi.git"
gem "resque", "1.24.1", :require => ["resque", "resque/server"]
gem "resque-scheduler", "2.0.1", :require => ["resque_scheduler", "resque_scheduler/server"]

group :production do
  gem 'rails_12factor'
  gem "unicorn"
end

group :assets do
  gem "uglifier", ">= 1.0.3"
  gem "sass-rails", "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"
end

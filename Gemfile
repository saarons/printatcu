source "http://rubygems.org"

gem "gon"
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
gem "rails", "3.2.13"
gem "bootstrap-sass-rails"
gem "nokogiri", "~> 1.5.10"
gem "daemon-spawn", :require => "daemon_spawn"
gem "resque", :require => ["resque", "resque/server"]
gem "shinobi", :git => "git://github.com/saarons/shinobi.git"
gem "resque-scheduler", :require => ["resque_scheduler", "resque_scheduler/server"]

group :production do
  gem "unicorn"
end

group :assets do
  gem "uglifier", ">= 1.0.3"
  gem "sass-rails", "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"
end
require "mina/bundler"
require "mina/rails"
require "mina/git"
require "mina/rvm"

set :domain, "printatcu"
set :deploy_to, "/var/www/printatcu"
set :repository, "git://github.com/saarons/printatcu.git"
set :branch, "master"

set :shared_paths, ["config/database.yml", "log", "public/uploads", "tmp/pids"]

task :environment do
  invoke :'rvm:use[ruby-1.9.3]'
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/uploads"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/uploads"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      if ENV["cold"]
        invoke :start
      else
        invoke :restart
      end
    end
  end
end

task :start do
  invoke :'resque:start'
  invoke :'resque_scheduler:start'
  invoke :'unicorn:start'
end

task :restart do
  invoke :'resque:restart'
  invoke :'resque_scheduler:restart'
  invoke :'unicorn:restart'
end

task :stop do
  invoke :'resque:stop'
  invoke :'resque_scheduler:stop'
  invoke :'unicorn:stop'
end

namespace :unicorn do
  task :start => :environment do
    queue "cd #{deploy_to}/#{current_path}"
    queue "UNICORN_PWD=#{deploy_to}/#{current_path} bin/unicorn -c config/unicorn.rb -E #{rails_env} -D"
  end

  task :restart do
    queue "kill -s HUP `cat #{deploy_to}/shared/tmp/pids/unicorn.pid`"
  end

  task :stop do
    queue "kill -s QUIT `cat #{deploy_to}/shared/tmp/pids/unicorn.pid`"
  end
end

namespace :resque do
  task :start => :environment do
    queue "cd #{deploy_to}/#{current_path}"
    queue "RAILS_ENV=#{rails_env} script/resque start"
  end

  task :restart => :environment do
    queue "cd #{deploy_to}/#{current_path}"
    queue "RAILS_ENV=#{rails_env} script/resque restart"
  end

  task :stop => :environment do
    queue "cd #{deploy_to}/#{current_path}"
    queue "RAILS_ENV=#{rails_env} script/resque stop"
  end
end

namespace :resque_scheduler do
  task :start => :environment do
    queue "cd #{deploy_to}/#{current_path}"
    queue "RAILS_ENV=#{rails_env} script/resque_scheduler start"
  end

  task :restart => :environment do
    queue "cd #{deploy_to}/#{current_path}"
    queue "RAILS_ENV=#{rails_env} script/resque_scheduler restart"
  end

  task :stop => :environment do
    queue "cd #{deploy_to}/#{current_path}"
    queue "RAILS_ENV=#{rails_env} script/resque_scheduler stop"
  end
end
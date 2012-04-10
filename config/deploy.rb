require "./config/boot"
require "rvm/capistrano"
require "bundler/capistrano"
require "airbrake/capistrano"

ssh_options[:port] = 815
ssh_options[:forward_agent] = true

default_run_options[:pty] = true

set :user, "sam"
set :application, "printatcu"

set :scm, "git"
set :branch, "master"
set :deploy_via, :remote_cache
set :repository, "git@github.com:saarons/printatcu.git"

server "printatcu.com", :app, :web, :db, :primary => true

set :rvm_ruby_string, "ruby-1.9.3"
set :rvm_type, :user

set :rails_env, :production
set :unicorn_binary, "bundle exec unicorn"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

task :setup_app_dir, :roles => :app do
  sudo "chown #{user}:#{user} -R #{deploy_to}"
end
after "deploy:setup", :setup_app_dir

task :symlink_uploads_folder, :roles => :app do  
  path  = "#{shared_path}/uploads"
  symlink_path = "#{release_path}/public/uploads"
  run "mkdir -p #{path}"
  run "rm -rf #{symlink_path}"
  run "ln -sf #{path} #{symlink_path}"
end
after "deploy:update_code", :symlink_uploads_folder

task :symlink_db, :roles => :db do
  run "mkdir -p #{shared_path}/config"
  upload "config/database.yml", "#{shared_path}/config/database.yml", :via => :scp, :mode => 0600
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end
after "deploy:finalize_update", :symlink_db

namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export, :roles => :app do
    run "#{sudo} whoami && cd #{release_path} && rvmsudo bundle exec foreman export upstart /etc/init -c worker=2, node=1 -e config/foreman/production.env -a #{application} -u #{user} -l #{shared_path}/log"
  end
end
after "deploy:update", "foreman:export"

namespace :deploy do
  task :start, :roles => :app, :except => { :no_release => true } do
    sudo "start #{application}"
    run "cd #{current_path} && UNICORN_PWD=#{current_path} #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    sudo "stop #{application}"
    run "kill `cat #{unicorn_pid}`"
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{sudo} restart #{application}"
    run "kill -s USR2 `cat #{unicorn_pid}`"
    run "kill -s WINCH `cat #{unicorn_pid}.oldbin`"
    run "kill -s QUIT `cat #{unicorn_pid}.oldbin`"
  end
  
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end
end
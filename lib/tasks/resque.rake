require "resque/tasks"
require "resque_scheduler/tasks"

namespace :resque do
  task :setup do
    require 'resque'
    require 'resque_scheduler'

    Resque.redis = 'localhost:6379'

    Resque.schedule = YAML.load_file('config/schedule.yml')
  end
end
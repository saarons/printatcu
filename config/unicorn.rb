worker_processes 2
pid "tmp/pids/unicorn.pid"
listen "/tmp/printatcu.sock"
working_directory ENV["UNICORN_PWD"]
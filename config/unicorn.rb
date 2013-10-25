worker_processes 2
pid "tmp/pids/unicorn.pid"
working_directory ENV["UNICORN_PWD"]
stderr_path "log/unicorn.stderr.log"
stdout_path "log/unicorn.stdout.log"
listen 5000
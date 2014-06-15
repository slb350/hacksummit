root = "/home/steve/apps/aninconvenientapp/current"
working_directory root
pid "#{root}/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.cpt.sock"
worker_processes 2
timeout 300
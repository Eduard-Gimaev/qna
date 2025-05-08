# frozen_string_literal: true

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
max_threads_count = ENV.fetch('RAILS_MAX_THREADS', 5)
min_threads_count = ENV.fetch('RAILS_MIN_THREADS', max_threads_count)
threads min_threads_count, max_threads_count

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
#
worker_timeout 3600 if ENV.fetch('RAILS_ENV', 'development') == 'development'

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
#
port ENV.fetch('PORT', 3000)

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch('RAILS_ENV', 'development')

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch('PIDFILE', 'tmp/pids/server.pid')

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

directory '/home/deployer/qna-app-server/current'
rackup "/home/deployer/qna-app-server/current/config.ru"
environment 'production'

pidfile "/home/deployer/qna-app-server/shared/tmp/pids/puma.pid"
state_path "/home/deployer/qna-app-server/shared/tmp/pids/puma.state"
stdout_redirect "/home/deployer/qna-app-server/shared/log/puma.stdout.log", "/home/deployer/qna-app-server/shared/log/puma.stderr.log", true

threads 1, 6
workers 2

bind "unix:///home/deployer/qna-app-server/shared/tmp/sockets/puma.sock"

daemonize true
prune_bundler

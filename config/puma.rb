# frozen_string_literal: true

max_threads_count = ENV.fetch('RAILS_MAX_THREADS', 5)
min_threads_count = ENV.fetch('RAILS_MIN_THREADS', max_threads_count)
threads min_threads_count, max_threads_count

worker_timeout 3600 if ENV.fetch('RAILS_ENV', 'development') == 'development'

port ENV.fetch('PORT', 3000)

environment ENV.fetch('RAILS_ENV', 'development')

pidfile ENV.fetch('PIDFILE', 'tmp/pids/server.pid')

plugin :tmp_restart

rackup "config.ru"

if ENV.fetch('RAILS_ENV', 'development') == 'production'
  pidfile "/home/deployer/qna-app-server/shared/tmp/pids/puma.pid"
  state_path "/home/deployer/qna-app-server/shared/tmp/pids/puma.state"
  stdout_redirect "/home/deployer/qna-app-server/shared/log/puma.stdout.log", "/home/deployer/qna-app-server/shared/log/puma.stderr.log", true
  bind "unix:///home/deployer/qna-app-server/shared/tmp/sockets/puma.sock"
end

threads 1, 6
workers 2

prune_bundler

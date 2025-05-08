# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

set :application, "qna-app-server"
set :repo_url, "git@github.com:Eduard-Gimaev/qna.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna-app-server"

# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"

set :default_env, {
  'PATH' => '$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH',
  'DATABASE_USERNAME' => 'postgres',
  'DATABASE_PASSWORD' => 'bQ^2_rAx-DNX+vH',
  'DATABASE_HOST' => '127.0.0.1',
  'DATABASE_PORT' => '5432'
}

set :branch, ENV['BRANCH'] || 'main'

set :bundle_jobs, 2

set :keep_releases, 3

# Puma configuration
set :puma_threads, [1, 6]
set :puma_workers, 2

set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{shared_path}/log/puma.access.log"
set :puma_error_log, "#{shared_path}/log/puma.error.log"

set :puma_preload_app, true
set :puma_daemonize, true
set :puma_init_active_record, true


Rake::Task['deploy:assets:precompile'].clear_actions

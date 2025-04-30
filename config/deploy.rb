# config valid for current version and patch releases of Capistrano
lock "~> 3.19.2"

set :application, "qna-app-server"
set :repo_url, "git@github.com:Eduard-Gimaev/qna.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna-app-server"

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

# Default value for :linked_files is []
append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "vendor", "storage"
# Load DSL and set up stages
require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git
require "capistrano/scm/git"
require "capistrano/bundler"
require "capistrano/rails"
require 'capistrano/puma'
require 'capistrano/puma/systemd'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }

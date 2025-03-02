# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

namespace :cleanup do
  desc 'Clear logs and tmp files'
  task clear: :environment do
    Rake::Task['log:clear'].invoke
    Rake::Task['tmp:clear'].invoke
  end
end
#bin/rails cleanup:clear

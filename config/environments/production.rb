# frozen_string_literal: true
require 'logger'
require 'active_support/core_ext/integer/time'

Rails.application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false
  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :amazon

  config.log_level = :info

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  config.action_mailer.perform_caching = false

  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Log disallowed deprecations.
  config.active_support.disallowed_deprecation = :log

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Use default logging formatter so that PID and timestamp are not suppressed.
  logfile = File.open(Rails.root.join("log", "#{Rails.env}.log"), "a")
  logfile.sync = true
  config.logger = ActiveSupport::Logger.new(logfile)
  config.logger.formatter = ::Logger::Formatter.new

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

end
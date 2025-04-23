require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'pundit/rspec'
require 'capybara/rspec'

Rails.root.glob('spec/support/**/*.rb').sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include ControllerHelpers, type: :controller
  config.include FeatureHelpers, type: :feature
  config.include ApiHelpers, type: :request

  Capybara.javascript_driver = :selenium_chrome_headless

  config.fixture_path = Rails.root.join('spec', 'fixtures')

  config.use_transactional_fixtures = true

  config.before do
    Rails.application.routes.default_url_options[:host] = 'example.com'
  end

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.after(:all) do
    FileUtils.rm_rf(Rails.root.join('tmp', 'storage', 'storage').to_s)
  end

  config.before do
    ActiveJob::Base.queue_adapter = :test
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

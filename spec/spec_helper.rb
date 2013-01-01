ENV['RAILS_ENV'] ||= 'test'
def verbose_require path
  puts "require '\e[36m#{path}\e[0m'" if ENV['verbose']
  require path
end
verbose_require 'spork'
verbose_require File.expand_path("../../config/environment", __FILE__)
verbose_require 'rspec/rails'
verbose_require 'rspec/autorun'
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| verbose_require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/treetop"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
end

Spork.prefork do
end
Spork.each_run do
end

def reload!
  puts "[Performing .reload!]"
  ActionDispatch::Reloader.cleanup!
  ActionDispatch::Reloader.prepare!
end


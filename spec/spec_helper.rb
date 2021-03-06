require "simplecov"
require "coveralls"
require "codeclimate-test-reporter"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter,
  CodeClimate::TestReporter::Formatter
]

SimpleCov.start do
  add_filter "/spec/"
end

MODELS = File.join(File.dirname(__FILE__), "app/models")
$LOAD_PATH.unshift(MODELS)

require "pry"
require "rails"
require "mongoid"
require "mongoid/socialization"
require "ammeter/init"
require "mongoid-rspec"

# mongoid connection
Mongoid.load! File.dirname(__FILE__) + "/config/mongoid.yml", :test

# Autoload every model for the test suite that sits in spec/app/models.
Dir[ File.join(MODELS, "*.rb") ].sort.each do |file|
  name = File.basename(file, ".rb")
  autoload name.camelize.to_sym, name
end

# silent deprecation warnings
I18n.enforce_available_locales = false

# initializers
load File.dirname(__FILE__) + "/config/initializers/setup.rb"

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.include Mongoid::Matchers, type: :model

  config.before(:each) do
    Mongoid.purge!
  end
end
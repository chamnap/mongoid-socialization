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
Mongoid::Socialization.conversationer_klass_name = "User"

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.include Mongoid::Matchers, type: :model

  config.before(:each) do
    Mongoid.purge!
  end
end

require 'bundler/setup'
require 'xmatters-sensu/version'
require 'sensu-handler'
require 'webmock/rspec'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture(relative_path)
  File.new(File.join(fixture_path, relative_path))
end

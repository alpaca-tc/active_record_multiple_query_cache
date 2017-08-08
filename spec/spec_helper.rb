require 'bundler/setup'
require 'active_record'
require 'active_record_multiple_query_cache'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.order = :random

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

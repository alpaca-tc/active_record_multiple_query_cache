ActiveRecord::Migrator.migrations_paths = [File.expand_path('../test/dummy/db/migrate', __FILE__)]

require File.expand_path('../dummy/config/environment.rb', __FILE__)
require 'rspec/rails'

ActiveRecord::Migration.maintain_test_schema!

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require(f) }

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true
end

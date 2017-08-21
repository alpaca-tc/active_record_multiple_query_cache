# Load schema_cache and connect to database
RSpec.configure do |config|
  config.before(:suite) do
    Item.first
    Post.first
  end
end

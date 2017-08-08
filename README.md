# ActiveRecordMultipleQueryCache

Enable the query_cache for your abstract base class inherited from ActiveRecord::Base.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record_multiple_query_cache'
```

## Usage

```ruby
# your custom base class
class ApplicationSlaveRecord < ActiveRecord::Base
  self.abstract_class = true
  establish_connection(:"slave_#{Rails.env}")
end

# config/initializers/active_record_multiple_query_cache.rb
ActiveRecordMultipleQueryCache.install_query_cache('ApplicationSlaveRecord')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Testing

```
bundle exec appraisal 4.2-stable rake all
bundle exec appraisal 5.0-stable rake all
bundle exec appraisal 5.1-stable rake all
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alpaca-tc/active_record_multiple_query_cache.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

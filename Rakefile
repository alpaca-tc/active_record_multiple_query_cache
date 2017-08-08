require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

desc 'Default: run unit tests.'
task default: [:all]

desc 'Test the paperclip plugin under all supported Rails versions.'
task :all do |t|
  ENV['RAILS_ENV'] ||= 'test'

  puts 'Create database'
  Dir.chdir('spec/dummy') do
    if Gem.loaded_specs['railties'].version >= Gem::Version.new('5.0.0')
      system('bundle exec rake db:environment:set RAILS_ENV=test')
      system({ 'RAILS_ENV' => 'test' }, 'bundle exec rake db:reset')
    else
      system({ 'RAILS_ENV' => 'test' }, 'bundle exec rake db:reset')
    end
  end

  puts 'rake spec'
  ENV['QUERY_CACHE_ENABLED'] = nil
  Rake::Task[:spec].execute

  puts 'QUERY_CACHE_ENABLED=1 rake spec'
  ENV['QUERY_CACHE_ENABLED'] = '1'
  Rake::Task[:spec].execute
end

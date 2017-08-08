require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

desc 'Default: run unit tests.'
task default: [:all]

desc 'Test the paperclip plugin under all supported Rails versions.'
task :all do |t|
  puts 'rake spec'
  ENV['QUERY_CACHE_ENABLED'] = nil
  Rake::Task[:spec].execute

  puts 'QUERY_CACHE_ENABLED=1 rake spec'
  ENV['QUERY_CACHE_ENABLED'] = '1'
  Rake::Task[:spec].execute
end

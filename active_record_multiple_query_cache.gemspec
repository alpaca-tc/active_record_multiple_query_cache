# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record_multiple_query_cache/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_record_multiple_query_cache'
  spec.version       = ActiveRecordMultipleQueryCache::VERSION
  spec.authors       = ['alpaca-tc']
  spec.email         = ['alpaca-tc@alpaca.tc']

  spec.summary       = %q{ActiveRecord::QueryCache}
  spec.description   = %q{ActiveRecord::QueryCache}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(spec)/})
  end

  spec.require_paths = ['lib']

  spec.add_dependency('activerecord', '>= 4.2')
  spec.add_development_dependency('bundler')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec')
end

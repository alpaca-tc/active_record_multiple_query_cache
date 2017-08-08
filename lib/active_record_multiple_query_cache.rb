require 'active_record_multiple_query_cache/version'
require 'active_record_multiple_query_cache/rails4_query_cache'

module ActiveRecordMultipleQueryCache
  autoload :Rails4QueryCache, 'active_record_multiple_query_cache/rails4_query_cache'
  autoload :Rails5QueryCache, 'active_record_multiple_query_cache/rails5_query_cache'

  def self.install_query_cache(activerecord_base_class_name, rails = Rails)
    if rails.gem_version >= Gem::Version.new('5.0.0')
      executor = ActiveSupport::Executor
      query_cache = Rails5QueryCache.new(activerecord_base_class_name)

      executor.register_hook(hook)
    else
      middleware = ActiveRecordMultipleQueryCache::Rails4QueryCache.new(activerecord_base_class_name)
      rails.configuration.app_middleware.insert_after('::ActionDispatch::Callbacks', middleware)
    end
  end
end

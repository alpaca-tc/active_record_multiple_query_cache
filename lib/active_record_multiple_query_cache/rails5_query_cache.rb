module ActiveRecordMultipleQueryCache
  class Rails5QueryCache < Base
    def run
      caching_pool = active_record_base_class.connection.pool
      caching_was_enabled = caching_pool.query_cache_enabled

      caching_pool.enable_query_cache!

      [caching_pool, caching_was_enabled]
    end

    def complete((caching_pool, caching_was_enabled))
      caching_pool.disable_query_cache! unless caching_was_enabled
    end
  end
end

module ActiveRecordMultipleQueryCache
  class Rails5QueryCache
    def initialize(active_record_base_name_or_class)
      @active_record_base_name_or_class = active_record_base_name_or_class
    end

    def run
      caching_pool = active_record_base_class.connection.pool
      caching_was_enabled = caching_pool.query_cache_enabled

      caching_pool.enable_query_cache!

      [caching_pool, caching_was_enabled]
    end

    def complete((caching_pool, caching_was_enabled))
      caching_pool.disable_query_cache! unless caching_was_enabled
    end

    private

    def active_record_base_class
      @active_record_base_class ||= if @active_record_base_name_or_class.is_a?(String)
                                      @active_record_base_name_or_class.constantize
                                    else
                                      @active_record_base_name_or_class
                                    end
    end
  end
end

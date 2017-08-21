if ENV['QUERY_CACHE_ENABLED']
  ActiveRecordMultipleQueryCache.install_query_cache('Item')
  ActiveRecordMultipleQueryCache.install_query_cache('Post')
end

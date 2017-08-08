require 'rack'
require 'active_support/core_ext/string/inflections'

module ActiveRecordMultipleQueryCache
  class Rails4QueryCache
    def initialize(app, active_record_base_class)
      active_record_base_class = active_record_base_class.constantize if active_record_base_class.is_a?(String)

      @app = app
      @active_record_base_class = active_record_base_class
    end

    def call(env)
      connection = @active_record_base_class.connection
      enabled = connection.query_cache_enabled
      connection_id = @active_record_base_class.connection_id
      connection.enable_query_cache!

      response = @app.call(env)
      response[2] = Rack::BodyProxy.new(response[2]) do
        restore_query_cache_settings(connection_id, enabled)
      end

      response
    rescue Exception
      restore_query_cache_settings(connection_id, enabled)
      raise
    end

    private

    def restore_query_cache_settings(connection_id, enabled)
      @active_record_base_class.connection_id = connection_id
      @active_record_base_class.connection.clear_query_cache
      @active_record_base_class.connection.disable_query_cache! unless enabled
    end
  end
end

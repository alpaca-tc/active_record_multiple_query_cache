module ActiveRecordMultipleQueryCache
  class Base
    def initialize(active_record_base_name_or_class)
      @active_record_base_name_or_class = active_record_base_name_or_class
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

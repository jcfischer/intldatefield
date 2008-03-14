module ActiveRecord
  module ConnectionAdapters
    class Column
      def date?
        :date == type
      end
      
      def time?
        [:datetime, :timestamp, :time].include? type
      end
      
      def binary?
        :binary == type
      end
      
      def boolean?
        :boolean == type
      end
    end
  end
end

module ActiveRecord
  module IntlDate

    #def self.included(base)
    #  base.extend(ClassMethods)
    #end

    # Updates the attribute identified by <tt>attr_name</tt> with the specified +value+. Empty strings for fixnum and float
    # columns are turned into nil.
    def write_attribute(attr_name, value)
      

      attr_name = attr_name.to_s
      @attributes_cache.delete(attr_name)
      if (column = column_for_attribute(attr_name)) 
        @attributes[attr_name] = convert_number_column_value(value) if column.number?
        @attributes[attr_name] = convert_time_column_value(value) if column.date? || column.time?
        @attributes[attr_name] = value if column.text? || column.binary? || column.boolean?
      else
        @attributes[attr_name] = value
      end
    end

    protected
    
    def convert_time_column_value(value)
      return value unless value.is_a?(String)
      
      dt = nil 
      ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.detect do |key, format|
        dt = DateTime.strptime(value, format) rescue nil
        dt
      end
      
      return dt if dt
      # try parsedate and give up, if it fails
      res = ParseDate.parsedate(value) 
      Time.local(*res) rescue value
    end    


  end
end

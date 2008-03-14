require 'intl_date'
ActiveRecord::Base.send(:include, ActiveRecord::IntlDate)
# ActiveRecord::ConnectionAdapters::Column.send(:include, ActiveRecord::IntlDate::Column)
module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(resources, filtering_params)
      results = resources
      filtering_params.each do |key, value|
        results = results.public_send("filter_by_#{key}", filter_value(value)) if value.present?
      end
      results
    end

    # 検索まわりの特殊な意味を持つ文字列を変換する
    def filter_value(value)
      case value
      when '-1'
        nil
      else
        value
      end
    end
  end
end

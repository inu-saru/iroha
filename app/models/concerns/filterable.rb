module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(resources, filtering_params)
      results = resources
      filtering_params.each do |key, value|
        results = resources.public_send("filter_by_#{key}", value) if value.present?
      end
      results
    end
  end
end

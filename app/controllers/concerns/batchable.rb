module Batchable
  extend ActiveSupport::Concern

  def batch_params
    return @batch_params if defined? @batch_params

    @batch_params = ActionController::Parameters.new(JSON.parse(request.body.read, symbolize_names: true))
  end
end

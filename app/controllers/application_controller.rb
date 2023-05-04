class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :bad_request
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::RoutingError, with: :not_found

  private

  def bad_request(error)
    render json: { message: "400 bad request: #{error.message}" }, status: :bad_request
  end

  def not_found(error)
    render json: { message: "404 not found: #{error.message}" }, status: :not_found
  end
end

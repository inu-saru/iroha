class Api::V1::Users::SessionsController < Devise::SessionsController
  include RackSessionFix
  respond_to :json
  wrap_parameters :user

  private

  def respond_with(resource, _opts = {})
    render json: resource
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        message: "logged out successfully"
      }, status: :ok
    else
      render json: {
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end

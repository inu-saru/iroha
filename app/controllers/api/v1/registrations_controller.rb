class Api::V1::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  respond_to :json
  wrap_parameters :user

  def create
    build_resource(sign_up_params)
    super
  end

  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message! :notice, :destroyed
    yield resource if block_given?
    render json: {
      message: "User was deleted successfully."
    }
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name)
  end

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: resource
    else
      render json: {
        message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"
      }, status: :unprocessable_entity
    end
  end
end

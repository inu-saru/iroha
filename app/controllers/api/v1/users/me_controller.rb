class Api::V1::Users::MeController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: { id: current_user.id, email: current_user.email, jti: current_user.jti, updated_at: current_user.updated_at, name: current_user.name,
                   created_at: current_user.created_at }
  end
end

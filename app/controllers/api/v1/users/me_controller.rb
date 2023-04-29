class Api::V1::Users::MeController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: UserResource.new(current_user).serialize
  end
end

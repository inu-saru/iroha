class Api::V1::Spaces::IndexController < ApplicationController
  before_action :authenticate_user!
  after_action { pagy_headers_merge(@pagy) if @pagy }
  wrap_parameters :space

  def index
    @pagy, @spaces = pagy(spaces)
    render json: SpaceResource.new(@spaces).serialize
  end

  def show
    render json: SpaceResource.new(space).serialize
  end

  def create
    render json: SpaceResource.new(spaces.create!(space_params)).serialize
  end

  def update
    space.update!(space_params)
    render json: SpaceResource.new(space).serialize
  end

  def destroy
    render json: SpaceResource.new(space.destroy!).serialize
  end

  private

  def space_params
    params.require(:space).permit(:name)
  end

  def space
    current_user.spaces.find(params[:id])
  end

  def spaces
    current_user.spaces.order(created_at: :desc)
  end
end

class Api::V1::Sections::IndexController < ApplicationController
  include Spaceable
  before_action :authenticate_user!
  after_action { pagy_headers_merge(@pagy) if @pagy }
  wrap_parameters :section

  def index
    @pagy, @sections = pagy(sections)
    render json: SectionResource.new(@sections).serialize
  end

  def show
    render json: SectionResource.new(section).serialize
  end

  def create
    render json: SectionResource.new(sections.create!(section_params)).serialize
  end

  def update
    section.update!(section_params)
    render json: SectionResource.new(section).serialize
  end

  def destroy
    render json: SectionResource.new(section.destroy!).serialize
  end

  private

  def section_params
    params.require(:section).permit(:name)
  end

  def sections
    return @sections if defined? @sections

    @sections = space.sections.order(created_at: :desc)
  end

  def section
    return @section if defined? @section

    @section = sections.find(params[:id])
  end
end

class Api::V1::Vocabularies::IndexController < ApplicationController
  include Spaceable
  before_action :authenticate_user!
  after_action { pagy_headers_merge(@pagy) if @pagy }
  wrap_parameters :vocabulary

  def index
    @vocabularies = Vocabulary.filter(vocabularies, filtering_params)
    @pagy, @vocabularies = pagy(@vocabularies)
    render json: VocabularyResource.new(@vocabularies).serialize
  end

  def show
    render json: VocabularyResource.new(vocabulary).serialize
  end

  def create
    render json: VocabularyResource.new(vocabularies.create!(vocabulary_params)).serialize
  end

  def update
    if vocabulary_params[:section_id].present?
      space.sections.find(vocabulary_params[:section_id])
    end

    vocabulary.update!(vocabulary_params)
    render json: VocabularyResource.new(vocabulary).serialize
  end

  def destroy
    render json: VocabularyResource.new(vocabulary.destroy!).serialize
  end

  private

  def vocabulary_params
    params.require(:vocabulary).permit(:vocabulary_type, :en, :ja, :section_id)
  end

  def filtering_params
    params.slice(:section_id, :vocabulary_type, :langage)
  end

  def vocabularies
    return @vocabularies if defined? @vocabularies

    @vocabularies = space.vocabularies.order(created_at: :desc)
  end

  def vocabulary
    return @vocabulary if defined? @vocabulary

    @vocabulary = vocabularies.find(params[:id])
  end
end

class Api::V1::Vocabularies::IndexController < ApplicationController
  include Spaceable
  include Batchable
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

  def batch_params
    return @batch_params if defined? @batch_params

    @batch_params = ActionController::Parameters.new(JSON.parse(request.body.read, symbolize_names: true))
  end

  def vocabulary_params
    this_params = request.env['FROM_BATCH_API'].present? ? batch_params : params
    this_params.require(:vocabulary).permit(:vocabulary_type, :en, :ja, :section_id)
  end

  def filtering_params
    params.slice(:sid, :vocabulary_type, :q)
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

class Api::V1::Relationships::IndexController < ApplicationController
  include Spaceable
  include Batchable
  before_action :authenticate_user!
  after_action { pagy_headers_merge(@pagy) if @pagy }
  wrap_parameters :relationship

  def index
    @relationships = Vocabulary.filter(relationships, filtering_params)
    @pagy, @relationships = pagy(@relationships)

    render json: RelationshipResource.new(relationships).serialize
  end

  def show
    render json: RelationshipResource.new(relationship).serialize
  end

  def create
    follower = vocabularies.find(relationship_params['follower_id'])
    followed = vocabularies.find(relationship_params['followed_id'])
    attr = {
      follower_id: follower.id,
      followed_id: followed.id,
      language_type: relationship_params['language_type'],
      positions: relationship_params['positions']
    }
    render json: RelationshipResource.new(relationships.create!(attr)).serialize
  end

  def update
    relationship.update!(relationship_params.slice(:positions))
    render json: RelationshipResource.new(relationship).serialize
  end

  def destroy
    render json: RelationshipResource.new(relationship.destroy!).serialize
  end

  private

  def relationship_params
    this_params = request.env['FROM_BATCH_API'].present? ? batch_params : params
    this_params.require(:relationship).permit(:follower_id, :followed_id, :language_type, positions: [])
  end

  def filtering_params
    params.slice(:language_type, :follower_id, :followed_id)
  end

  def relationships
    return @relationships if defined? @relationships

    @relationships = space.relationships.order(created_at: :asc)
  end

  def relationship
    return @relationship if defined? @relationship

    @relationship = relationships.find(params[:id])
  end

  def vocabularies
    return @vocabularies if defined? @vocabularies

    @vocabularies = space.vocabularies.order(created_at: :desc)
  end
end

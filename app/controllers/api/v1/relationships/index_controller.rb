class Api::V1::Relationships::IndexController < ApplicationController
  include Spaceable
  before_action :authenticate_user!
  wrap_parameters :relationship

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

  def batch_params
    return @batch_params if defined? @batch_params

    @batch_params = ActionController::Parameters.new(JSON.parse(request.body.read, symbolize_names: true))
  end

  def relationship_params
    this_params = request.env['FROM_BATCH_API'].present? ? batch_params : params
    this_params.require(:relationship).permit(:follower_id, :followed_id, :language_type, positions: [])
  end

  def relationships
    return @relationships if defined? @relationships

    @relationships = space.relationships.order(created_at: :desc)
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

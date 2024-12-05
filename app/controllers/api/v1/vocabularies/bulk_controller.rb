class Api::V1::Vocabularies::BulkController < ApplicationController
  include Spaceable
  before_action :authenticate_user!
  wrap_parameters :vocabulary

  def create
    q = vocabulary_params['q']
    @section_id = vocabulary_params['section_id'] || nil
    targets = %w[en ja]
    exclude_poses = %w[ADP AUX DET PRON PUNCT]
    exclde_followed_tagets = ['ja']
    followed_targets = targets.filter_map do |target|
      next if exclde_followed_tagets.include?(target)

      target
    end

    followed_params = OroshiApiClient.post_translate(q:, targets:)
    followed = space.vocabularies.create!(vocabulary_create_params(followed_params, 'sentence'))
    create_relationships(followed, targets, followed_targets, exclude_poses, followed_params)

    render json: VocabularyWithRelationshipsResource.new(followed).serialize
  end

  private

  def vocabulary_params
    params.require(:vocabulary).permit(:q, :section_id)
  end

  def fetch_or_create_word(relationship)
    language_type = relationship['relationship']['language_type']
    space.vocabularies.find_by(language_type.to_sym => relationship['vocabulary'][language_type],
                               vocabulary_type: 'word') || space.vocabularies.create!(vocabulary_create_params(
                                                                                        relationship['vocabulary'], 'word'
                                                                                      ))
  end

  def vocabulary_create_params(params, vocabulary_type)
    params.merge({ vocabulary_type:, section_id: @section_id })
  end

  def create_relationships(followed, targets, followed_targets, exclude_poses, followed_params)
    followed_targets.each do |followed_target|
      relationships_params = OroshiApiClient.post_translate_relations(q: followed_params[followed_target], targets:, exclude_poses:)
      relationships_params.map do |relationship|
        follower = fetch_or_create_word(relationship)
        relationship_params = {
          follower_id: follower.id,
          followed_id: followed.id,
          language_type: relationship['relationship']['language_type'],
          positions: relationship['relationship']['positions']
        }
        space.relationships.create(relationship_params)
      end
    end
  end
end

class FollowResource < BaseResource
  attributes :id, :vocabulary_type, :en, :ja, :section_id, :updated_at, :created_at, :relationship_id, :positions

  attribute :language_type do |follow|
    Relationship.language_types.key(follow.language_type)
  end
end

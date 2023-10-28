class RelationshipResource < BaseResource
  attributes :id, :language_type, :positions, :updated_at, :created_at

  attribute :follower do |relationship|
    VocabularyResource.new(relationship.follower).to_h
  end

  attribute :followed do |relationship|
    VocabularyResource.new(relationship.followed).to_h
  end
end

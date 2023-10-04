class RelationshipResource < BaseResource
  attributes :id, :follower_id, :followed_id, :language_type, :positions, :updated_at, :created_at
end

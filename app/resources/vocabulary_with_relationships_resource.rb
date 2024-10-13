class VocabularyWithRelationshipsResource < BaseResource
  attribute :vocabulary do |vocabulary|
    VocabularyResource.new(vocabulary).to_h
  end

  attribute :relationships do |vocabulary|
    VocabularyResource.new(vocabulary.followers).to_h
  end
end

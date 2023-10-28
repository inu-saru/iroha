class Relationship < ApplicationRecord
  belongs_to :space
  belongs_to :follower, class_name: 'Vocabulary'
  belongs_to :followed, class_name: 'Vocabulary'

  enum :language_type, { en: 0, ja: 1 }

  scope :filter_by_language_type, ->(language_type) { where language_type: }
  scope :filter_by_follower_id, ->(follower_id) { where follower_id: }
  scope :filter_by_followed_id, ->(followed_id) { where followed_id: }
end

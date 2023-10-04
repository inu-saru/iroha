class Vocabulary < ApplicationRecord
  include Filterable

  validates :en, length: { maximum: 1000 }
  validates :ja, length: { maximum: 1000 }
  validate :required_at_least_one_language

  belongs_to :space
  belongs_to :section, optional: true
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy,
                                  inverse_of: :follower
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy,
                                   inverse_of: :followed
  has_many :following, through: :active_relationships, source: :followed do
    def with
      select('relationships.id AS relationship_id', :positions, :language_type, arel_table[Arel.star])
    end
  end
  has_many :followers, through: :passive_relationships, source: :follower do
    def with
      select('relationships.id AS relationship_id', :positions, :language_type, arel_table[Arel.star])
    end
  end

  enum :vocabulary_type, { word: 0, idiom: 1, sentence: 2 }

  scope :filter_by_sid, ->(sid) { where section_id: sid }
  scope :filter_by_vocabulary_type, ->(vocabulary_type) { where vocabulary_type: }
  scope :filter_by_q, ->(q) do
    where("en ILIKE ?", "%#{q}%")
      .or(where("ja ILIKE ?", "%#{q}%"))
  end

  def required_at_least_one_language
    return if en.present? || ja.present?

    errors.add(:language, 'is required at (least one language)')
  end
end

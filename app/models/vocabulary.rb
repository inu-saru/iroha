class Vocabulary < ApplicationRecord
  include Filterable

  validates :en, length: { maximum: 1000 }
  validates :ja, length: { maximum: 1000 }
  validate :required_at_least_one_language

  belongs_to :space
  belongs_to :section, optional: true

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

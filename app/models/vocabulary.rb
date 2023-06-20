class Vocabulary < ApplicationRecord
  include Filterable

  validates :en, length: { maximum: 1000 }
  validates :ja, length: { maximum: 1000 }
  validate :required_at_least_one_langage

  belongs_to :space
  belongs_to :section, optional: true

  enum :vocabulary_type, { word: 0, idiom: 1, sentence: 2 }

  scope :filter_by_sid, ->(sid) { where section_id: sid }
  scope :filter_by_vocabulary_type, ->(vocabulary_type) { where vocabulary_type: }
  scope :filter_by_q, ->(q) do
    where("en LIKE ?", "%#{q}%")
      .or(where("ja LIKE ?", "%#{q}%"))
  end

  def required_at_least_one_langage
    return if en.present? || ja.present?

    errors.add(:langage, 'is required at (least one langage)')
  end
end

class Vocabulary < ApplicationRecord
  include Filterable

  validates :en, length: { maximum: 1000 }
  validates :ja, length: { maximum: 1000 }
  validate :required_at_least_one_langage

  belongs_to :space
  belongs_to :section, optional: true

  enum :vocabulary_type, { word: 0, idiom: 1, sentence: 2 }

  scope :filter_by_section_id, ->(section_id) { where section_id: }
  scope :filter_by_vocabulary_type, ->(vocabulary_type) { where vocabulary_type: }
  scope :filter_by_langage, ->(langage) do
    where("en LIKE ?", "%#{langage}%")
      .or(where("ja LIKE ?", "%#{langage}%"))
  end

  def required_at_least_one_langage
    return if en.present? || ja.present?

    errors.add(:langage, 'is required at (least one langage)')
  end
end

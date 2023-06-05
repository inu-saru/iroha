class Vocabulary < ApplicationRecord
  validates :en, length: { maximum: 1000 }
  validates :ja, length: { maximum: 1000 }
  validate :required_at_least_one_langage

  belongs_to :space
  belongs_to :section, optional: true

  enum :vocabulary_type, { word: 0, idiom: 1, sentence: 2 }

  private

  def required_at_least_one_langage
    return if en.present? || ja.present?

    errors.add(:langage, 'is required at (least one langage)')
  end
end

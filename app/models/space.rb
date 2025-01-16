class Space < ApplicationRecord
  extend ArrayEnum
  array_enum language_types: Language::TYPES

  validates :name, length: { minimum: 1, maximum: 255 }
  validate :language_types_is_needed_over_two

  has_many :space_users, dependent: :destroy
  has_many :users, through: :space_users
  has_many :sections, dependent: :destroy
  has_many :vocabularies, dependent: :destroy
  has_many :relationships, dependent: :destroy

  private

  def language_types_is_needed_over_two
    if language_types.size < 2
      errors.add(:language_types, 'language_types is needed over two')
    end
  end
end

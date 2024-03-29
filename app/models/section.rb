class Section < ApplicationRecord
  validates :name, length: { minimum: 1, maximum: 255 }

  belongs_to :space
  has_many :vocabularies, dependent: :nullify
end

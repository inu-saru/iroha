class Space < ApplicationRecord
  validates :name, length: { minimum: 1, maximum: 255 }

  has_many :space_users, dependent: :destroy
  has_many :users, through: :space_users
  has_many :sections, dependent: :destroy
  has_many :vocabularies, dependent: :destroy
  has_many :relationships, dependent: :destroy
end

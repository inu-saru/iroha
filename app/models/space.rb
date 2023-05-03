class Space < ApplicationRecord
  validates :name, length: { minimum: 1, maximum: 255 }
end

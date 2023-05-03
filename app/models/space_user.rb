class SpaceUser < ApplicationRecord
  belongs_to :space
  belongs_to :user

  validates :user_id, uniqueness: { scope: :space_id }
end

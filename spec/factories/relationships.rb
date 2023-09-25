FactoryBot.define do
  factory :relationship do
    space { nil }
    follower { nil }
    followed { nil }
    language_type { 0 }
    positions { [] }
  end
end

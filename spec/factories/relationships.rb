FactoryBot.define do
  factory :relationship do
    space { nil }
    follower { nil }
    followed { nil }
    language_type { 0 }
    positions { [] }
  end

  factory :relationship_with, class: 'Relationship' do
    association :space
    follower { create(:word, space:) }
    followed { create(:sentence, space:) }
    language_type { 0 }
    positions { [] }
  end
end

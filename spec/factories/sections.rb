FactoryBot.define do
  factory :section do
    space { nil }
    name { FFaker::LoremJA.word }
  end

  factory :section_with, class: 'Section' do
    space { create(:space_user_with).space }
    name { FFaker::LoremJA.word }
  end
end

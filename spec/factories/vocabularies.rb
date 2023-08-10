FactoryBot.define do
  factory :word, class: 'Vocabulary' do
    vocabulary_type { 0 }
    en { FFaker::Lorem.word }
    ja { FFaker::LoremJA.word }
    space { nil }
    section { nil }
  end

  factory :sentence, class: 'Vocabulary' do
    vocabulary_type { 2 }
    en { FFaker::Lorem.sentence }
    ja { FFaker::LoremJA.sentence }
    space { nil }
    section { nil }
  end

  factory :sentence_with, class: 'Vocabulary' do
    vocabulary_type { 2 }
    en { FFaker::Lorem.sentence }
    ja { FFaker::LoremJA.sentence }

    transient do
      space_user { create(:space_user_with) }
    end
    space { space_user.space }
    section { create(:section, space: space_user.space) }
  end
end

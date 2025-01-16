FactoryBot.define do
  factory :space do
    name { FFaker::LoremJA.word }
    language_types { %w[en ja] }
  end
end

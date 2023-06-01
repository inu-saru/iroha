FactoryBot.define do
  factory :section do
    space { nil }
    name { FFaker::LoremJA.word }
  end
end

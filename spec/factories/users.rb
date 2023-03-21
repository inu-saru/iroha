FactoryBot.define do
  factory :user do
    transient do
      gimei { Gimei.name }
      set_password { SecureRandom.hex(10) }
    end
    name { gimei.kanji }
    email { FFaker::Internet.email }
    password { set_password }
  end
end

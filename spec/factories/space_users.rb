FactoryBot.define do
  factory :space_user do
    space { nil }
    user { nil }
  end

  factory :a_space_the_user, class: 'SpaceUser' do
    space { create(:space) }
    user { nil }
  end

  factory :space_user_with, class: 'SpaceUser' do
    space { create(:space) }
    user { create(:user) }
  end
end

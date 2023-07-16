3.times do |i|
  user = FactoryBot.create(:user, email: "test#{i}@test.com", password: ENV.fetch("SEED_USER_PASSWORD", nil))
  space_user = FactoryBot.create(:a_space_the_user, user:)
  # sectionなしのsentence
  3.times { FactoryBot.create(:sentence, space: space_user.space) }
  # sectionありのsentence
  3.times do
    section = FactoryBot.create(:section, space: space_user.space)
    3.times { FactoryBot.create(:sentence, space: space_user.space, section:) }
  end
end

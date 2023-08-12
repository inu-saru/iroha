require "csv"

3.times do |i|
  user = FactoryBot.create(:user, email: "test#{i}@test.com", password: ENV.fetch("SEED_USER_PASSWORD", nil))
  space_user = FactoryBot.create(:a_space_the_user, user:)
  # sectionなしのsentence
  3.times { FactoryBot.create(:sentence, space: space_user.space) }
  # sectionありのsentence
  CSV.foreach('db/csv/duo_light.csv') do |row|
    section = Section.find_or_create_by(space: space_user.space, name: row[0])
    FactoryBot.create(:sentence, space: space_user.space, en: row[1], ja: row[2], section:)
  end
end

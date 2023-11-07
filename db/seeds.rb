require "csv"

3.times do |i|
  user = FactoryBot.create(:user, email: "test#{i}@test.com", password: ENV.fetch("SEED_USER_PASSWORD", nil))
  space_user = FactoryBot.create(:a_space_the_user, user:)
  space = space_user.space
  # sectionなしのsentence
  3.times { FactoryBot.create(:sentence, space:) }
  # sectionありのsentence
  CSV.foreach('db/csv/duo_light.csv', headers: true) do |row|
    section = Section.find_or_create_by(space:, name: row['section'])
    FactoryBot.create(:sentence, space:, en: row['en'], ja: row['ja'], section:)
  end
  # relationship
  CSV.foreach('db/csv/duo_word_light.csv', headers: true) do |row|
    sentence = Vocabulary.find_by(space:, en: row['followed'])
    word = Vocabulary.create(space:, section: sentence.section, en: row['en'], ja: row['ja'])
    Relationship.create(space:, followed: sentence, follower: word, positions: row['positions'])
  end
end

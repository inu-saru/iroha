require 'rails_helper'

RSpec.describe Vocabulary do
  let(:space1) { create(:space) }
  let(:section1) { create(:section, space: space1) }
  let(:sentence1) { create(:sentence, space: space1) }

  it '登録できること' do
    sentence = Vocabulary.create(attributes_for(:sentence, space: space1, section: section1))
    expect(sentence).to be_valid
  end

  describe 'validation' do
    describe 'en' do
      it '1000文字以下の場合は有効であること' do
        section = build(:sentence, space: space1, en: 'a' * 1000)
        expect(section).to be_valid
      end

      it '1001文字以上の場合無効であること' do
        section = build(:sentence, space: space1, en: 'a' * 1001)
        expect(section).not_to be_valid
        expect(section.errors[:en]).to include("is too long (maximum is 1000 characters)")
      end
    end

    describe 'ja' do
      it '1000文字以下の場合は有効であること' do
        section = build(:sentence, space: space1, ja: 'a' * 1000)
        expect(section).to be_valid
      end

      it '1001文字以上の場合無効であること' do
        section = build(:sentence, space: space1, ja: 'a' * 1001)
        expect(section).not_to be_valid
        expect(section.errors[:ja]).to include("is too long (maximum is 1000 characters)")
      end
    end

    describe 'en ja' do
      it 'すべてのlanguageがnilの場合無効であること' do
        section = build(:sentence, space: space1, en: nil, ja: nil)
        expect(section).not_to be_valid
        expect(section.errors[:language]).to include("is required at (least one language)")
      end

      it 'いずれかのlanguageがnilの場合有効であること' do
        section = build(:sentence, space: space1, ja: nil)
        expect(section).to be_valid
      end
    end

    describe 'space' do
      it 'spaceが無しで登録できないこと' do
        sentence = Vocabulary.create(attributes_for(:sentence))
        expect(sentence).not_to be_valid
      end
    end

    describe 'section' do
      it 'section無しで登録できること' do
        sentence = Vocabulary.create(attributes_for(:sentence, space: space1))
        expect(sentence).to be_valid
      end
    end
  end

  describe 'following / follower' do
    let(:word1) { create(:word, space: space1) }
    let(:relationship1) { create(:relationship, space: space1, follower: word1, followed: sentence1) }

    before do
      relationship1
    end

    it 'followingの情報が正しく取得できること' do
      expect(word1.following.first).to eq(sentence1)
    end

    it 'followersの情報が正しく取得できること' do
      expect(sentence1.followers.first).to eq(word1)
    end
  end

  describe 'with(_relationship)' do
    let(:word1) { create(:word, space: space1) }
    let(:relationship1) { create(:relationship, space: space1, follower: word1, followed: sentence1) }

    before do
      relationship1
    end

    it 'followingがwithを介した場合に、中間テーブルの情報が取得できること' do
      expect(word1.following.with.first.relationship_id).to eq(relationship1.id)
      # TODO: arelで中間テーブルの値を付与した場合、enumがnumの状態で返ってしまう
      expect(word1.following.with.first.language_type).to eq(relationship1.read_attribute_before_type_cast(:language_type))
      expect(word1.following.with.first.positions).to eq(relationship1.positions)
    end

    it 'followerがwithを介した場合に、中間テーブルの情報が取得できること' do
      expect(sentence1.followers.with.first.relationship_id).to eq(relationship1.id)
      # TODO: arelで中間テーブルの値を付与した場合、enumがnumの状態で返ってしまう
      expect(sentence1.followers.with.first.language_type).to eq(relationship1.read_attribute_before_type_cast(:language_type))
      expect(sentence1.followers.with.first.positions).to eq(relationship1.positions)
    end
  end
end

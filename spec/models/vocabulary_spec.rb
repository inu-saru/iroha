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
end

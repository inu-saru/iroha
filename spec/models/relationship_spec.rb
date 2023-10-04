require 'rails_helper'

RSpec.describe Relationship do
  let(:space1) { create(:space) }
  let(:section1) { create(:section, space: space1) }
  let(:sentence1) { create(:sentence, space: space1) }
  let(:word1) { create(:word, space: space1) }
  let(:relationship1) { create(:relationship, space: space1, follower: word1, followed: sentence1) }

  it '登録できること' do
    expect(relationship1).to be_valid
  end

  describe 'valid' do
    it 'followed, following, language_typeが同じ場合、登録できないこと' do
      relationship1
      same_relationship = build(:relationship, space: space1, follower: word1, followed: sentence1)
      expect do
        same_relationship.save
      end.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it 'followed, followingが同じ場合でも、language_typeが違う場合、登録できること' do
      relationship1
      other_relationship = build(:relationship, space: space1, follower: word1, followed: sentence1, language_type: 'ja')
      expect do
        other_relationship.save
      end.to change(Relationship, :count).by(1)
    end
  end

  describe 'space' do
    it 'spaceがない場合は無効であること' do
      relationship = build(:relationship, follower: word1, followed: sentence1, language_type: 'ja')
      expect(relationship).not_to be_valid
      expect(relationship.errors[:space]).to include("must exist")
    end
  end
end

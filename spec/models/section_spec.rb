require 'rails_helper'

RSpec.describe Section do
  let(:space1) { create(:space) }

  it '登録できること' do
    section = Section.create(attributes_for(:section, space: space1))
    expect(section).to be_valid
  end

  describe 'validation' do
    describe 'name' do
      it '255文字以下の場合は有効であること' do
        section = build(:section, space: space1, name: 'a' * 255)
        expect(section).to be_valid
      end

      it '256文字以上の場合無効であること' do
        section = build(:section, space: space1, name: 'a' * 256)
        expect(section).not_to be_valid
        expect(section.errors[:name]).to include("is too long (maximum is 255 characters)")
      end

      it 'nilの場合無効であること' do
        section = build(:section, space: space1, name: nil)
        expect(section).not_to be_valid
        expect(section.errors[:name]).to include("is too short (minimum is 1 character)")
      end
    end

    describe 'space' do
      it 'spaceがない場合は無効であること' do
        section = build(:section, name: 'a' * 255)
        expect(section).not_to be_valid
        expect(section.errors[:space]).to include("must exist")
      end
    end
  end
end

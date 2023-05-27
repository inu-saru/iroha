require 'rails_helper'

RSpec.describe Space do
  it '登録できること' do
    space = Space.create(attributes_for(:space))
    expect(space).to be_valid
  end

  describe 'validation' do
    describe 'name' do
      it '255文字以下の場合は有効であること' do
        space = build(:space, name: 'a' * 255)
        expect(space).to be_valid
      end

      it '256文字以上の場合無効であること' do
        space = build(:space, name: 'a' * 256)
        expect(space).not_to be_valid
        expect(space.errors[:name]).to include("is too long (maximum is 255 characters)")
      end

      it 'nilの場合無効であること' do
        space = build(:space, name: nil)
        expect(space).not_to be_valid
        expect(space.errors[:name]).to include("is too short (minimum is 1 character)")
      end
    end
  end
end

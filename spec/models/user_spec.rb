require 'rails_helper'

RSpec.describe User do
  it '登録できること' do
    user = User.create(attributes_for(:user))
    expect(user).to be_valid
  end

  describe 'validation' do
    context 'email' do
      it '不正なemailは無効であること' do
        user = build(:user, email: 'aaabbb')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("is invalid")
      end

      it '重複したemailは無効であること' do
        create(:user, email: 'test@example.com')
        user = build(:user, email: 'test@example.com')
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include('has already been taken')
      end

      it '大文字のemailはdowncaseされて登録されること' do
        user = build(:user, email: 'TEST@example.COM')
        expect(user).to be_valid
        expect(user.email).to eq('test@example.com')
      end

      it 'nilの場合エラーになること' do
        user = build(:user, email: nil)
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end
    end

    context 'name' do
      it '指定がない場合も登録できること' do
        name_empty_user = User.create(attributes_for(:user).tap { |hash| hash.delete(:name) })
        expect(name_empty_user).to be_valid
        expect(name_empty_user.name).to eq ""
      end
    end

    context 'password' do
      it 'nilの場合エラーになること' do
        user = build(:user, password: nil)
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("can't be blank")
      end

      it '5文字以下のpasswordは無効であること' do
        user = build(:user, password: "12345")
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
      end
    end
  end
end

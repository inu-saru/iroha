require 'rails_helper'

RSpec.describe 'POST /api/v1/signup' do
  let(:user1) { create(:user) }
  let(:user_response) do
    {
      id: a_kind_of(Integer),
      name: a_kind_of(String),
      email: match(/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i),
      jti: a_kind_of(String),
      created_at: a_kind_of(String),
      updated_at: a_kind_of(String)
    }
  end

  context '有効なparamsの場合' do
    it '1件のUserが登録されること' do
      params[:user] = attributes_for(:user).slice(:email, :password)

      expect do
        subject
      end.to change(User, :count).by(1)
      expect(response).to have_http_status(:ok)
      user_response.store(:email, params[:user][:email])
      expect(json_response).to include(user_response)
      expect(json_response.size).to eq 6
    end
  end

  context 'params[:email]の形式が不正の場合' do
    it '無効であること' do
      params[:user] = attributes_for(:user, email: 'this_is_not_maild_address')

      subject
      expect do
        subject
      end.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:message]).to eq "User couldn't be created successfully. Email is invalid"
    end
  end

  context 'params[:email]が重複する場合' do
    it '無効であること' do
      user1
      params[:user] = attributes_for(:user, email: user1.email)

      subject
      expect do
        subject
      end.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:message]).to eq "User couldn't be created successfully. Email has already been taken"
    end
  end

  context 'params[:email]が未指定の場合' do
    it '無効であること' do
      params[:user] = attributes_for(:user).tap { |hash| hash.delete(:email) }

      subject
      expect do
        subject
      end.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:message]).to eq "User couldn't be created successfully. Email can't be blank"
    end
  end

  context 'params[:email]が空文字の場合' do
    it '無効であること' do
      params[:user] = attributes_for(:user, email: '')

      subject
      expect do
        subject
      end.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:message]).to eq "User couldn't be created successfully. Email can't be blank"
    end
  end

  context 'params[:email]がnilの場合' do
    it '無効であること' do
      params[:user] = attributes_for(:user, email: nil)

      subject
      expect do
        subject
      end.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:message]).to eq "User couldn't be created successfully. Email can't be blank"
    end
  end

  context 'params[:password]が5文字以下の場合' do
    it '無効であること' do
      params[:user] = attributes_for(:user, password: '12345')

      subject
      expect do
        subject
      end.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:message]).to eq "User couldn't be created successfully. Password is too short (minimum is 6 characters)"
    end
  end

  context 'params[:password]が129文字以上の場合' do
    it '無効であること' do
      params[:user] = attributes_for(:user, password: FFaker::Internet.password(129))

      subject
      expect do
        subject
      end.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:message]).to eq "User couldn't be created successfully. Password is too long (maximum is 128 characters)"
    end
  end

  context 'params[:password]が未指定の場合' do
    it '無効であること' do
      params[:user] = attributes_for(:user).tap { |hash| hash.delete(:password) }

      subject
      expect do
        subject
      end.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:message]).to eq "User couldn't be created successfully. Password can't be blank"
    end
  end

  context 'params[:password]が空文字の場合' do
    it '無効であること' do
      params[:user] = attributes_for(:user, password: '')

      subject
      expect do
        subject
      end.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:message]).to eq "User couldn't be created successfully. Password can't be blank"
    end
  end

  context 'params[:password]がnilの場合' do
    it '無効であること' do
      params[:user] = attributes_for(:user, password: nil)

      subject
      expect do
        subject
      end.not_to change(User, :count)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:message]).to eq "User couldn't be created successfully. Password can't be blank"
    end
  end
end

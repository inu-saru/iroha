require 'rails_helper'

RSpec.describe 'POST /api/v1/login' do
  let!(:user1) { create(:user) }
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
    it '指定したUser情報が更新されること' do
      params[:user] = { email: user1.email, password: user1.password }

      subject
      expect(response).to have_http_status(:ok)
      user_response.store(:email, params[:user][:email])
      expect(json_response).to include(user_response)
      expect(json_response.size).to eq 6
    end
  end

  context 'passwordが間違っている場合' do
    it '401エラーが返ること' do
      params[:user] = { email: user1.email, password: 'wrong_password' }

      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context '登録されていないメールアドレスを指定した場合' do
    let!(:unregistered_user_params) { attributes_for(:user) }

    it '401エラーが返ること' do
      params[:user] = { email: unregistered_user_params[:email], password: unregistered_user_params[:password] }

      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

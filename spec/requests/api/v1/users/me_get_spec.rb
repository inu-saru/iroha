require 'rails_helper'

RSpec.describe 'GET /api/v1/users/me' do
  let!(:user1) { create(:user) }
  let(:token1) { login_token(user1) }
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

  context '有効期限(30分)内のTokenの場合' do
    before do
      travel_to(Time.current.ago(29.minutes))
      headers['Authorization'] = token1
      travel_back
    end

    it 'Auth User情報が返ること' do
      subject
      expect(response).to have_http_status(:ok)
      expect(json_response).to include(user_response)
      expect(json_response.size).to eq 6
    end
  end

  context '有効期限(30分)外のTokenの場合' do
    before do
      travel_to(Time.current.ago(30.minutes))
      headers['Authorization'] = token1
      travel_back
    end

    it '401エラーが返ること' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'ログアウトしたTokenの場合' do
    before do
      headers['Authorization'] = token1
    end

    it '401エラーが返ること' do
      get(api_v1_users_me_path, headers:)
      expect(response).to have_http_status(:ok)
      delete(destroy_user_session_path, headers:)
      expect(response).to have_http_status(:ok)

      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'Tokenがない場合' do
    it '401エラーが返ること' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

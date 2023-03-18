require 'rails_helper'

RSpec.describe 'PUT /api/v1/signup' do
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

  context 'with Authorization header' do
    before do
      headers['Authorization'] = login_token(user1)
    end

    describe 'name' do
      it '指定したUser情報が更新されること' do
        params[:user] = { name: 'update_name' }

        subject
        expect(response).to have_http_status(:ok)
        user_response.store(:name, params[:user][:name])
        expect(json_response).to include(user_response)
        expect(json_response.size).to eq user_response.size
      end
    end

    describe 'email' do
      it '指定したUser情報が更新されないこと' do
        params[:user] = { email: 'update@example.com' }

        subject
        expect(response).to have_http_status(:ok)
        expect(json_response[:email]).not_to eq params[:user][:email]
      end
    end
  end

  context 'without Authorization header' do
    it '401エラーが返ること' do
      params[:user] = { name: 'update_name' }

      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

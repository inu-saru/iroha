require 'rails_helper'

RSpec.describe 'POST /api/v1/spaces' do
  let(:user1) { create(:user) }
  let(:token1) { login_token(user1) }

  context 'Tokenがない場合' do
    it '401エラーが返ること' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context '有効なTokenがある場合' do
    before do
      headers['Authorization'] = token1
    end

    it 'ログインユーザーの所有する1件のSpaceが登録されること' do
      params[:space] = attributes_for(:space).slice(:name)

      expect do
        subject
      end.to change(Space, :count).by(1).and change(SpaceUser, :count).by(1)
      expect(response).to have_http_status(:ok)
      created_space = Space.find(json_response[:id])
      expect(created_space.users).to include user1
    end

    it '不正なparamsの場合、400エラーが返ること' do
      params[:space] = { name: '' }

      subject
      expect(response).to have_http_status(:bad_request)
    end
  end
end

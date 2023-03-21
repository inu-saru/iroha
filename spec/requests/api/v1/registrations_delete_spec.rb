require 'rails_helper'

RSpec.describe 'DELETE /api/v1/registration' do
  let!(:user1) { create(:user) }

  context 'with Authorization header' do
    before do
      headers['Authorization'] = login_token(user1)
    end

    it '指定したUser情報が削除されること' do
      expect do
        subject
      end.to change(User, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end
  end

  context 'without Authorization header' do
    it '401エラーが返ること' do
      expect do
        subject
      end.not_to change(User, :count)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

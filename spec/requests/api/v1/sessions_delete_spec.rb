require 'rails_helper'

RSpec.describe 'DELETE /api/v1/logout' do
  let!(:user1) { create(:user) }

  context 'with Authorization header' do
    before do
      headers['Authorization'] = login_token(user1)
    end

    it 'ログアウトができること' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  context 'without Authorization header' do
    it 'reuturn 401' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

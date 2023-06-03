require 'rails_helper'

RSpec.describe 'DELETE /api/v1/spaces/:space_id' do
  let(:user1) { create(:user) }
  let(:token1) { login_token(user1) }
  let(:space1) { create(:space) }

  let(:other_user1) { create(:user) }
  let(:other_space1) { create(:space) }

  let(:space_id) { space1.id }

  before do
    create(:space_user, { space: space1, user: user1 })
    create(:space_user, { space: other_space1, user: other_user1 })
  end

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

    context 'ownerであるspace.idの場合' do
      it '正しく削除できること' do
        expect do
          subject
        end.to change(Space, :count).by(-1).and change(SpaceUser, :count).by(-1)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'ownerでないspace.idの場合' do
      let(:space_id) { other_space1.id }

      it '404エラーが返ること' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

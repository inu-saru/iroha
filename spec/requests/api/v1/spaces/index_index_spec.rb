require 'rails_helper'

RSpec.describe 'GET /api/v1/spaces' do
  let(:user1) { create(:user) }
  let(:token1) { login_token(user1) }
  let(:space1) { create(:space) }
  let(:space2) { create(:space) }

  let(:other_user1) { create(:user) }
  let(:other_space1) { create(:space) }

  before do
    create(:space_user, { space: space1, user: user1 })
    create(:space_user, { space: space2, user: user1 })
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

    it 'ownerであるspaceのみ返されること' do
      subject
      expect(response).to have_http_status(:ok)
      expect(json_response.first).to eq json_attributes(SpaceResource.new(space1).serialize)
      expect(json_response.second).to eq json_attributes(SpaceResource.new(space2).serialize)
    end

    it 'ownerでないspaceが返されないこと' do
      subject
      expect(response).to have_http_status(:ok)
      expect(json_response).not_to include json_attributes(SpaceResource.new(other_space1).serialize)
    end
  end
end

require 'rails_helper'

RSpec.describe 'GET /api/v1/spaces/:space_id/vocabularies/:vocabulary_id/following' do
  let(:user1) { create(:user) }
  let(:token1) { login_token(user1) }
  let(:space1) { create(:space) }
  let(:space_id) { space1.id }
  let(:sentence1) { create(:sentence, space: space1) }
  let(:word1) { create(:word, space: space1) }

  let(:vocabulary_id) { word1.id }

  before do
    create(:space_user, { space: space1, user: user1 })
    create(:relationship, space: space1, follower: word1, followed: sentence1)
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

    context '指定したspaceがownerであるspace.idの場合' do
      it '正しくspace情報が返ること' do
        subject
        expect(response).to have_http_status(:ok)
        expect(json_response).to eq json_attributes(FollowResource.new(word1.following.with).serialize)
      end
    end
  end
end

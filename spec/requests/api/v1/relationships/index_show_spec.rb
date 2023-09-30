require 'rails_helper'

RSpec.describe 'GET /api/v1/spaces/:space_id/relationships/:relationship_id' do
  let(:user1) { create(:user) }
  let(:token1) { login_token(user1) }
  let(:space1) { create(:space) }
  let(:space_id) { space1.id }
  let(:sentence1) { create(:sentence, space: space1) }
  let(:word1) { create(:word, space: space1) }
  let(:relationship1) { create(:relationship, space: space1, follower: word1, followed: sentence1) }
  let(:relationship_id) { relationship1.id }

  before do
    create(:space_user, { space: space1, user: user1 })
    relationship1
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

    context '指定したspaceがownerであるrelationship.idの場合' do
      it '正しくspace情報が返ること' do
        subject
        expect(response).to have_http_status(:ok)
        expect(json_response).to eq json_attributes(RelationshipResource.new(relationship1).serialize)
      end
    end

    context '指定したspaceがownerでないrelationship.idの場合' do
      let(:space2) { create(:space) }
      let(:relationship_in_space2) do
        create(:relationship, space: space2, follower: create(:sentence, space: space2), followed: create(:word, space: space2))
      end
      let(:relationship_id) { relationship_in_space2.id }

      before do
        create(:space_user, { space: space2, user: user1 })
      end

      it '404エラーが返ること' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'userがownerでないspaceとrelationship.idを指定した場合' do
      let(:other_space_relationship1) { create(:relationship_with) }
      let(:space_id) { other_space_relationship1.space.id }
      let(:relationship_id) { other_space_relationship1.id }

      it '404エラーが返ること' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

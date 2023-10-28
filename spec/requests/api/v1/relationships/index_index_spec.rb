require 'rails_helper'

RSpec.describe 'GET /api/v1/spaces/:space_id/relationships' do
  let(:user1) { create(:user) }
  let(:token1) { login_token(user1) }
  let(:space1) { create(:space) }
  let(:space_id) { space1.id }
  let(:relationship1) { create(:relationship_with, space: space1) }
  let(:relationship2) { create(:relationship_with, space: space1) }

  before do
    create(:space_user, { space: space1, user: user1 })
    relationship1
    relationship2
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

    it '正しくspace情報が返ること、orderが作成日のascであること' do
      subject
      expect(response).to have_http_status(:ok)
      expect(json_response).to eq json_attributes(RelationshipResource.new([relationship1, relationship2]).serialize)
    end

    it 'relationshipが20件以上ある場合、正しく情報が返されること' do
      19.times { create(:relationship_with, space: space1) }

      subject
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq 20

      get(api_v1_space_relationships_path, headers:, params: { page: 2 })
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq 1
    end

    context '指定したspaceがownerでないrelationshipがある場合' do
      let(:space2) { create(:space) }
      let(:relationship_in_space2) do
        create(:relationship, space: space2, follower: create(:sentence, space: space2), followed: create(:word, space: space2))
      end

      before do
        create(:space_user, { space: space2, user: user1 })
      end

      it '指定したspaceがownerでないealtionshipが返らないこと' do
        subject
        expect(json_response).to eq json_attributes(RelationshipResource.new([relationship1, relationship2]).serialize)
      end
    end

    context 'userがownerでないspaceとrelationship.idを指定した場合' do
      let(:other_space_relationship1) { create(:relationship_with) }
      let(:space_id) { other_space_relationship1.space.id }

      it '404エラーが返ること' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end

    describe 'filter sid(follower_id)' do
      let(:follower) { relationship1.follower }

      before do
        params['follower_id'] = follower.id
      end

      it 'follower_idに指定したvocabularyがフォローしているvocabulariesが返ること' do
        # vocabulary/:follower_id/followingと同じものが返る
        subject

        expect(response).to have_http_status(:ok)
        expect(json_response).to match(
          [
            hash_including(
              follower: hash_including(id: follower.id)
            )
          ]
        )
      end
    end

    describe 'filter sid(followed_id)' do
      let(:followed) { relationship1.followed }

      before do
        params['followed_id'] = followed.id
      end

      it 'followed_idに指定したvocabularyのフォロワーであるvocabulariesが返ること' do
        # vocabulary/:followed_id/followerと同じものが返る
        subject

        expect(response).to have_http_status(:ok)
        expect(json_response).to match(
          [
            hash_including(
              followed: hash_including(id: followed.id)
            )
          ]
        )
      end
    end

    describe 'filter language_type' do
      let(:relationship_ja) { create(:relationship_with, space: space1, language_type: 'ja') }

      before do
        relationship_ja
        params['language_type'] = 'ja'
      end

      it 'jaのみ返されること' do
        subject

        expect(response).to have_http_status(:ok)
        expect(json_response).to eq json_attributes(RelationshipResource.new([relationship_ja]).serialize)
      end
    end
  end
end

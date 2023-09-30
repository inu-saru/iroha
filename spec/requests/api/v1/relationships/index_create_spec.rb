require 'rails_helper'

RSpec.describe 'POST /api/v1/spaces/:space_id/relationships' do
  let(:user1) { create(:user) }
  let(:token1) { login_token(user1) }
  let(:space1) { create(:space) }
  let(:space_id) { space1.id }
  let(:sentence1) { create(:sentence, space: space1) }
  let(:word1) { create(:word, space: space1) }

  before do
    create(:space_user, { space: space1, user: user1 })
  end

  context 'Tokenがない場合' do
    it '401エラーが返ること' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context '有効なTokenがある場合' do
    let(:create_params) do
      {
        follower_id: word1.id,
        followed_id: sentence1.id,
        language_type: "en",
        positions: [
          3
        ]
      }
    end

    before do
      headers['Authorization'] = token1
    end

    it '指定したspaceが所有する1件のRelationshipが登録されること' do
      params[:relationship] = create_params

      expect do
        subject
      end.to change(Relationship, :count).by(1)
      expect(response).to have_http_status(:ok)
      created_relationship = Relationship.find(json_response[:id])
      expect(created_relationship.space).to eq space1
    end

    context '指定したspaceに所属していないvocabulary.idをfollowに指定した場合' do
      let(:space2) { create(:space) }
      let(:sentence_in_space2) { create(:sentence, space: space2) }
      let(:word_in_space2) { create(:word, space: space2) }

      it '404エラーが返ること' do
        params[:relationship] = {
          follower_id: word_in_space2,
          followed_id: sentence_in_space2
        }

        subject
        expect(response).to have_http_status(:not_found)
      end
    end

    context '所属していないspaceを指定した場合' do
      let(:other_space1) { create(:space_user_with).space }
      let(:space_id) { other_space1.id }

      it '404エラーが返ること' do
        params[:relationship] = create_params

        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

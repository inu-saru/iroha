require 'rails_helper'

RSpec.describe 'POST /api/v1/spaces/:space_id/vocabularies' do
  let(:user1) { create(:user) }
  let(:token1) { login_token(user1) }
  let(:space1) { create(:space) }
  let(:space_id) { space1.id }

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
    before do
      headers['Authorization'] = token1
    end

    it '指定したspaceが所有する1件のVocabularyが登録されること' do
      params[:vocabulary] = attributes_for(:sentence).slice(:en)

      expect do
        subject
      end.to change(Vocabulary, :count).by(1)
      expect(response).to have_http_status(:ok)
      created_vocabulary = Vocabulary.find(json_response[:id])
      expect(created_vocabulary.space).to eq space1
    end

    it '不正なparamsの場合、400エラーが返ること' do
      params[:vocabulary] = { en: nil, ja: nil }

      subject
      expect(response).to have_http_status(:bad_request)
    end

    context '所属していないspaceを指定した場合' do
      let(:other_space1) { create(:space_user_with).space }
      let(:space_id) { other_space1.id }

      it '404エラーが返ること' do
        params[:vocabulary] = attributes_for(:sentence).slice(:en)

        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

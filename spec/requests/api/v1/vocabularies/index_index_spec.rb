require 'rails_helper'

RSpec.describe 'GET /api/v1/spaces/:space_id/vocabularies' do
  let(:user1) { create(:user) }
  let(:token1) { login_token(user1) }
  let(:space1) { create(:space) }
  let(:space_id) { space1.id }
  let(:other_space1) { create(:space_user_with).space }
  let(:sentence1) { create(:sentence, space: space1) }
  let(:sentence2) { create(:sentence, space: space1) }
  let(:other_space_sentence1) { create(:sentence_with) }

  before do
    create(:space_user, { space: space1, user: user1 })
    sentence1
    sentence2
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

    it '指定したspaceがownerのsentenceのみ返され、orderが作成日のdescであること' do
      other_space_sentence1

      subject
      expect(response).to have_http_status(:ok)
      expect(json_response.first).to eq json_attributes(VocabularyResource.new(sentence2).serialize)
      expect(json_response.second).to eq json_attributes(VocabularyResource.new(sentence1).serialize)
    end

    it '指定したspaceがownerでないsentenceが返されないこと' do
      other_space_sentence1

      subject
      expect(response).to have_http_status(:ok)
      expect(json_response).not_to include json_attributes(VocabularyResource.new(other_space_sentence1).serialize)
    end

    it 'sentenceが20件以上ある場合、正しく情報が返されること' do
      19.times { create(:sentence, space: space1) }

      subject
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq 20

      get(api_v1_space_vocabularies_path, headers:, params: { page: 2 })
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq 1
    end

    context 'userがownerでないspaceを指定した場合' do
      let(:space_id) { other_space1.id }

      it '404エラーが返ること' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

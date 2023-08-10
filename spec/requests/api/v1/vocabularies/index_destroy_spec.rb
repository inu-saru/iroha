require 'rails_helper'

RSpec.describe 'DELETE /api/v1/spaces/:space_id/vocabularies/:sentence_id' do
  let(:user1) { create(:user) }
  let(:token1) { login_token(user1) }
  let(:space1) { create(:space) }
  let(:space_id) { space1.id }
  let(:sentence1) { create(:sentence, space: space1) }
  let(:sentence_id) { sentence1.id }

  before do
    create(:space_user, { space: space1, user: user1 })
    sentence1
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

    context '指定したspaceがownerであるvocabulary.idの場合' do
      it '正しく削除できること' do
        expect do
          subject
        end.to change(Vocabulary, :count).by(-1)
        expect(response).to have_http_status(:ok)
      end
    end

    context '指定したspaceがownerでないvocabulary.idの場合' do
      let(:space2) { create(:space) }
      let(:sentence_in_space2) { create(:section, space: space2) }
      let(:sentence_id) { sentence_in_space2.id }

      before do
        sentence_in_space2
      end

      it '404エラーが返ること' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'userがownerでないspaceとvocabulary.idを指定した場合' do
      let(:other_space_sentence1) { create(:sentence_with) }
      let(:space_id) { other_space_sentence1.space.id }
      let(:sentence_id) { other_space_sentence1.id }

      it '404エラーが返ること' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe 'PUT /api/v1/spaces/:space_id/vocabularies/:vocabulary_id' do
  let(:user1) { create(:user) }
  let(:token1) { login_token(user1) }
  let(:space1) { create(:space) }
  let(:space_id) { space1.id }
  let(:sentence1) { create(:sentence, space: space1) }
  let(:vocabulary_id) { sentence1.id }

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
    let(:update_params) { { en: 'update_en_value', ja: 'update_ja_value' } }

    before do
      headers['Authorization'] = token1
      params[:vocabulary] = update_params
    end

    context '指定したspaceがownerであるvocabulary.idの場合' do
      it '正しく更新したspace情報が返ること' do
        subject
        expect(response).to have_http_status(:ok)
        updated_attribute = json_attributes(VocabularyResource.new(sentence1).serialize).merge(update_params)
        expect(json_response).to eq updated_attribute
      end

      describe 'sectionの更新について' do
        let(:space2) { create(:space) }
        let(:section1) { create(:section, space: space1) }
        let(:section_in_space2) { create(:section, space: space2) }

        before do
          create(:space_user, { space: space2, user: user1 })
          section1
        end

        it 'userがonwerであるsection.idの場合、変更できること' do
          params[:vocabulary][:section_id] = section1.id

          subject
          expect(response).to have_http_status(:ok)
          updated_attribute = json_attributes(VocabularyResource.new(sentence1).serialize).merge(params[:vocabulary])
          expect(json_response).to eq updated_attribute
        end

        it 'userがonwerであるsection.idの場合で、spaceが違う場合、404エラーが返ること' do
          params[:vocabulary][:section_id] = section_in_space2.id

          subject
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context '指定したspaceがownerでないvocabulary.idの場合' do
      let(:other_space_sentence1) { create(:sentence_with) }
      let(:vocabulary_id) { other_space_sentence1.id }

      it '404エラーが返ること' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'userがownerでないspaceとvocabulary.idを指定した場合' do
      let(:other_space_sentence1) { create(:sentence_with) }
      let(:space_id) { other_space_sentence1.space.id }
      let(:vocabulary_id) { other_space_sentence1.id }

      it '404エラーが返ること' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

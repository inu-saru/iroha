require 'rails_helper'

RSpec.describe 'POST /api/v1/batch' do
  let(:user1) { create(:user) }
  let(:token1) { login_token(user1) }
  let(:space1) { create(:space) }
  let(:space_id) { space1.id }
  let(:sentence1) { create(:sentence, space: space1) }

  before do
    create(:space_user, { space: space1, user: user1 })
  end

  context '有効なTokenがある場合' do
    before do
      headers['Authorization'] = token1
    end

    context 'すべてのrequestが成功する場合' do
      it 'vocabularyの作成とrelationshipのレコードが1件ずつ作成されていること、そのrelationshipの関係が正しいこと' do
        params[:requests] = [
          {
            method: 'POST',
            url: "/api/v1/spaces/#{space_id}/vocabularies",
            body: { vocabulary: { en: 'new word', ja: '新しい単語' } },
            # 後段で利用するためresponse.id(post後に作成されるvocabulary_id)をfollower_idとして登録する
            store: { id: 'follower_id' }
          },
          {
            method: 'POST',
            url: "/api/v1/spaces/#{space_id}/relationships",
            body: { relationship: {
              followed_id: sentence1.id,
              language_type: "en",
              positions: [
                3
              ]
            } },
            # 全段で登録されたstoreをbody要素にmergeする
            store_merge_to: 'relationship'
          }
        ]

        expect do
          subject
        end.to change(Vocabulary, :count).by(1).and change(Relationship, :count).by(1)
        expect(sentence1.followers.first[:en]).to eq 'new word'
        expect(sentence1.followers.first[:ja]).to eq '新しい単語'
        expect(sentence1.passive_relationships.first[:language_type]).to eq 'en'
        expect(sentence1.passive_relationships.first[:positions]).to eq [3]

        expect(json_response.first[:body][:en]).to eq 'new word'
        expect(json_response.first[:body][:ja]).to eq '新しい単語'
        expect(json_response.second[:body][:language_type]).to eq 'en'
        expect(json_response.second[:body][:positions]).to eq [3]
      end
    end

    context '前段のrequestが失敗した場合' do
      it 'すべてのrequestの影響がないこと、各ステータスが返ること' do
        valid_error_value = 'a' * 1001

        params[:requests] = [
          {
            method: 'POST',
            url: "/api/v1/spaces/#{space_id}/vocabularies",
            body: { vocabulary: { en: valid_error_value, ja: '新しい単語' } },
            # 後段で利用するためresponse.id(post後に作成されるvocabulary_id)をfollower_idとして登録する
            store: { id: 'follower_id' }
          },
          {
            method: 'POST',
            url: "/api/v1/spaces/#{space_id}/relationships",
            body: { relationship: {
              followed_id: sentence1.id,
              language_type: "en",
              positions: [
                3
              ]
            } },
            # 全段で登録されたstoreをbody要素にmergeする
            store_merge_to: 'relationship'
          }
        ]

        expect do
          subject
        end.to not_change(Vocabulary, :count)
          .and not_change(Relationship, :count)
        expect(json_response.first[:status]).to eq 400
        expect(json_response.second[:status]).to eq 404
      end
    end

    context '後段のrequestが失敗したばあい場合' do
      it 'すべてのrequestの影響がないこと、各ステータスが返ること' do
        duplicate_params = {
          method: 'POST',
          url: "/api/v1/spaces/#{space_id}/relationships",
          body: { relationship: {
            followed_id: sentence1.id,
            language_type: "en",
            positions: [
              3
            ]
          } },
          store_merge_to: 'relationship'
        }

        params[:requests] = [
          {
            method: 'POST',
            url: "/api/v1/spaces/#{space_id}/vocabularies",
            body: { vocabulary: { en: 'new word', ja: '新しい単語' } },
            # 後段で利用するためresponse.id(post後に作成されるvocabulary_id)をfollower_idとして登録する
            store: { id: 'follower_id' }
          },
          duplicate_params,
          duplicate_params
        ]

        expect do
          subject
        end.to not_change(Vocabulary, :count)
          .and not_change(Relationship, :count)
        expect(json_response.first[:status]).to eq 200
        expect(json_response.second[:status]).to eq 200
        expect(json_response.third[:status]).to eq 400
      end
    end
  end
end

require 'rails_helper'

RSpec.describe 'POST /api/v1/spaces/:space_id/vocabularies/bulk' do
  let(:user1) { create(:user) }
  let(:token1) { login_token(user1) }
  let(:space1) { create(:space) }
  let(:space_id) { space1.id }

  let(:translate_response) { { "en" => "We must respect the will of the individual.", "ja" => "私たちは個人の意志を尊重しなければなりません。" } }
  let(:en_followed_relations_response) do
    [
      { "meta" => { "pos" => "VERB" }, "relationship" => { "language_type" => "en", "positions" => [2] }, "vocabulary" => { "en" => "respect", "ja" => "尊敬" } },
      { "meta" => { "pos" => "NOUN" }, "relationship" => { "language_type" => "en", "positions" => [4] }, "vocabulary" => { "en" => "will", "ja" => "意思" } },
      { "meta" => { "pos" => "NOUN" }, "relationship" => { "language_type" => "en", "positions" => [7] },
        "vocabulary" => { "en" => "individual", "ja" => "個人" } }
    ]
  end
  # let(:ja_followed_relations_response) {[
  #   {'meta'=>{'pos'=>'NOUN'}, 'relationship'=>{'language_type'=>'ja', 'positions'=>[0]}, 'vocabulary'=>{'en'=>'personal', 'ja'=>'個人的'}},
  #   {'meta'=>{'pos'=>'NOUN'}, 'relationship'=>{'language_type'=>'ja', 'positions'=>[2]}, 'vocabulary'=>{'en'=>'will', 'ja'=>'意思'}},
  #   {'meta'=>{'pos'=>'VERB'}, 'relationship'=>{'language_type'=>'ja', 'positions'=>[4]}, 'vocabulary'=>{'en'=>'respect', 'ja'=>'尊敬'}},
  # ]}

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

      allow(OroshiApiClient).to receive(:post_translate).and_return(translate_response)
      allow(OroshiApiClient).to receive(:post_translate_relations).and_return(en_followed_relations_response)
    end

    it '指定したspaceが所有する1件のVocabularと、単語3件が関連語として登録されていること' do
      params[:vocabulary] = { q: 'We must respect the will of the individual.' }

      expect do
        subject
      end.to change(Vocabulary, :count).by(4)
      expect(response).to have_http_status(:ok)

      created_followed = Vocabulary.find(json_response[:vocabulary][:id])
      expect(created_followed.space).to eq space1
      expect(created_followed.vocabulary_type).to eq 'sentence'
      expect(created_followed.followers[0].space).to eq space1
      expect(created_followed.followers[0].vocabulary_type).to eq 'word'
      expect(created_followed.followers[1].space).to eq space1
      expect(created_followed.followers[1].vocabulary_type).to eq 'word'
      expect(created_followed.followers[2].space).to eq space1
      expect(created_followed.followers[2].vocabulary_type).to eq 'word'
    end

    context 'bulkで作成される同じ単語が、すでに登録してある場合' do
      let(:word1) { create(:word, space: space1, en: 'respect') }

      it '同じ単語が重複して登録されていないこと、既存の単語が作成したVocabulary(sentence)のfollowerに登録されていること' do
        params[:vocabulary] = { q: 'We must respect the will of the individual.' }
        word1

        expect do
          subject
        end.to change(Vocabulary, :count).by(3)
        expect(Vocabulary.all.where(en: 'respect').size).to eq 1

        created_followed = Vocabulary.all.find_by(en: 'We must respect the will of the individual.')
        expect(created_followed.followers).to include word1
      end
    end
  end
end

require 'rails_helper'

RSpec.describe 'GET /api/v1/spaces/:space_id/sections' do
  let(:user1) { create(:user) }
  let(:token1) { login_token(user1) }
  let(:space1) { create(:space) }
  let(:space_id) { space1.id }
  let(:space2) { create(:space) }
  let(:section1) { create(:section, space: space1) }
  let(:section2) { create(:section, space: space1) }
  let(:section_in_space2) { create(:section, space: space2) }

  before do
    create(:space_user, { space: space1, user: user1 })
    section1
    section2
    create(:space_user, { space: space2, user: user1 })
    section_in_space2
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

    it '指定したspaceがownerのsectionのみ返され、orderが作成日のdescであること' do
      subject
      expect(response).to have_http_status(:ok)
      expect(json_response.first).to eq json_attributes(SectionResource.new(section2).serialize)
      expect(json_response.second).to eq json_attributes(SectionResource.new(section1).serialize)
      expect(json_response).not_to include json_attributes(SectionResource.new(section_in_space2).serialize)
    end

    context 'userが所有しないspaceを指定した場合' do
      let(:other_space_section1) { create(:section_with) }
      let(:space_id) { other_space_section1.space.id }

      it '404エラーが返ること' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end

    it 'sectionが20件以上ある場合、正しく情報が返されること' do
      19.times { create(:section, space: space1) }

      subject
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq 20

      get(api_v1_space_sections_path, headers:, params: { page: 2 })
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq 1
    end
  end
end

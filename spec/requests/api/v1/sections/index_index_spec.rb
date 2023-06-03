require 'rails_helper'

RSpec.describe 'GET /api/v1/spaces/:space_id/sections' do
  let(:user1) { create(:user) }
  let(:token1) { login_token(user1) }
  let(:space1) { create(:space) }
  let(:space_id) { space1.id }
  let(:section1) { create(:section, space: space1) }
  let(:section2) { create(:section, space: space1) }
  let(:other_space_section1) { create(:section_with) }

  before do
    create(:space_user, { space: space1, user: user1 })
    section1
    section2
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
      other_space_section1

      subject
      expect(response).to have_http_status(:ok)
      expect(json_response.first).to eq json_attributes(SectionResource.new(section2).serialize)
      expect(json_response.second).to eq json_attributes(SectionResource.new(section1).serialize)
    end

    it '指定したspaceがownerでないsectionが返されないこと' do
      other_space_section1

      subject
      expect(response).to have_http_status(:ok)
      expect(json_response).not_to include json_attributes(SectionResource.new(other_space_section1).serialize)
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

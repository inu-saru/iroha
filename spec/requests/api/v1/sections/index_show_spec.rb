require 'rails_helper'

RSpec.describe 'GET /api/v1/spaces/:space_id/sections/:section_id' do
  let(:user1) { create(:user) }
  let(:token1) { login_token(user1) }
  let(:space1) { create(:space) }
  let(:space_id) { space1.id }
  let(:section1) { create(:section, space: space1) }
  let(:section_id) { section1.id }

  before do
    create(:space_user, { space: space1, user: user1 })
    section1
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

    context '指定したspaceがownerであるspace.idの場合' do
      it '正しくspace情報が返ること' do
        subject
        expect(response).to have_http_status(:ok)
        expect(json_response).to eq json_attributes(SectionResource.new(section1).serialize)
      end
    end

    context '指定したspaceがownerでないsection.idの場合' do
      let(:space2) { create(:space) }
      let(:section_in_space2) { create(:section, space: space2) }
      let(:section_id) { section_in_space2.id }

      before do
        create(:space_user, { space: space2, user: user1 })
      end

      it '404エラーが返ること' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'userがownerでないspaceとsection.idを指定した場合' do
      let(:other_space_section1) { create(:section_with) }
      let(:space_id) { other_space_section1.space.id }
      let(:section_id) { other_space_section1.id }

      it '404エラーが返ること' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end

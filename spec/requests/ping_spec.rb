require 'rails_helper'

RSpec.describe 'GET /api/v1/ping' do
  it 'success/200' do
    subject
    expect(response).to have_http_status(:ok)
  end
end

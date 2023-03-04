require 'rails_helper'

RSpec.describe 'Ping API' do
  it 'success/200' do
    get api_v1_ping_index_path
    expect(response).to be_successful
    expect(response).to have_http_status(:ok)
  end
end

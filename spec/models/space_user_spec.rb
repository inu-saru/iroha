require 'rails_helper'

RSpec.describe SpaceUser do
  let(:space1) { create(:space) }
  let(:user1) { create(:user) }

  it 'SpaceからUserが登録ができる' do
    space1.users << user1
    expect(space1.users.count).to eq 1
  end

  it 'UserからSpaceを追加で登録ができる' do
    user1.spaces << space1
    expect(user1.spaces.count).to eq 1
  end

  it 'SpaceとUserが同じものは追加できないこと' do
    space1.users << user1
    expect(space1.users.count).to eq 1
    expect do
      space1.users << user1
    end.to raise_error(/User has already been taken/)
  end
end

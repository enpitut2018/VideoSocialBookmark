require 'spec_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'GET /api/v1/current_user' do 
  end

  describe 'GET /api/v1/current_user/icon' do 
  end



  describe 'GET /api/v1/users/:id' do
    let(:user) { create(:user) }
    before { @users = [user] }
    it 'returns user with :id' do
      get "/api/v1/users/#{user.id}" do
        expect(JSON.parse(response.body)['name']).to eq user.name
      end
    end
  end
  describe 'GET /users/:id/bookmarks' do
  end
end

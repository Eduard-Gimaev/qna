require 'rails_helper'
RSpec.describe 'Comments API', type: :request do
  describe 'POST /api/v1/questions/:id/comments' do
    let(:headers) { { "Content-Type" => "application/json", "ACCEPT" => "application/json" } }
    let(:api_path) { "/api/v1/questions/#{question.id}/comments" }
    let(:access_token) { create(:access_token) }
    let(:current_user) { User.find(access_token.resource_owner_id) }
    let(:question) { create(:question, user: current_user) }

    before do
      auth_headers = headers.merge("Authorization" => "Bearer #{access_token.token}")
      post api_path, params: { comment: { body: 'API comment' } }.to_json, headers: auth_headers
    end

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:api_path) { "/api/v1/questions/#{question.id}/comments" }
    end
    
    it 'creates and returns the comment' do
      expect(response).to have_http_status(:created)
      expect(json_response['comment']['body']).to eq 'API comment'
      expect(json_response['comment']['user_id']).to eq current_user.id
      expect(question.reload.comments.count).to eq 1
    end
  end

end


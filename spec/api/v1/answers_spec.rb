require 'rails_helper'

RSpec.describe 'Answers API', type: :request do
  let(:current_user) { User.find(access_token.resource_owner_id) }
  let(:headers) { { "Content-Type" => "application/json", "ACCEPT" => "application/json" } }
  let(:api_path) { "/api/v1/answers/#{answer.id}" }
  let(:access_token) { create(:access_token) }
  let(:auth_headers) { headers.merge("Authorization" => "Bearer #{access_token.token}") }
  let(:question) { create(:question, user: current_user) }
  let(:answer) { create(:answer, question: question, user: current_user) }
  let(:comments) { create_list(:comment, 2, commentable: answer, user: current_user) }

  describe 'POST /api/v1/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    it 'creates an answer for the question' do
      post api_path, params: { answer: { body: 'This is an answer' } }.to_json, headers: auth_headers
      expect(response).to have_http_status(:created)
      expect(json_response['answer']['body']).to eq('This is an answer')
    end
  end

  describe 'PUT /api/v1/answers/:id' do
   
    it 'updates an answer' do
      put api_path, params: { answer: { body: 'Updated Answer' } }.to_json, headers: auth_headers
      expect(response).to have_http_status(:ok)
      expect(json_response['answer']['body']).to eq('Updated Answer')
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    it 'deletes an answer' do
      delete api_path, headers: headers.merge("Authorization" => "Bearer #{access_token.token}")
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let!(:comments) { create_list(:comment, 2, commentable: answer, user: current_user) }
    let!(:links) { create_list(:link, 2, linkable: answer) }
    let!(:files) { answer.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), 
                                          filename: 'rails_helper.rb') }
    before do
      get api_path, headers: headers.merge("Authorization" => "Bearer #{access_token.token}")
    end

    it 'returns the answer' do
      expect(response).to have_http_status(:ok)
      expect(json_response['answer']['id']).to eq(answer.id)
      expect(json_response['answer']['body']).to eq(answer.body)
    end

    it 'returns comments for the answer' do
      expect(json_response['answer']['comments'].size).to eq 2
    end

    it 'returns links for the answer' do
      expect(json_response['answer']['links'].size).to eq 2
    end

    it 'returns files for the answer' do
      expect(json_response['answer']['files'].first).to include('rails_helper.rb')
    end
  end

end

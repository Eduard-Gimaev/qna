require 'rails_helper'

RSpec.describe Api::V1::AnswersController do
  let(:current_user) { User.find(access_token.resource_owner_id) }
  let(:headers) { { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' } }
  let(:api_path) { "/api/v1/answers/#{answer.id}" }
  let(:access_token) { create(:access_token) }
  let(:auth_headers) { headers.merge('Authorization' => "Bearer #{access_token.token}") }
  let(:answer) do
    create(:answer,
           question: create(:question, user: current_user),
           user: current_user)
  end

  it_behaves_like 'API Authorizable' do
    let(:method) { :get }
  end

  describe 'POST /api/v1/answers' do
    let(:api_path) { "/api/v1/questions/#{answer.question.id}/answers" }

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
      delete api_path, headers: headers.merge('Authorization' => "Bearer #{access_token.token}")
      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'GET /api/v1/answers/:id' do
    before do
      create_list(:comment, 2, commentable: answer, user: current_user)
      create_list(:link, 2, linkable: answer)
      answer.files.attach(io: Rails.root.join('spec', 'rails_helper.rb').open, filename: 'rails_helper.rb')

      get api_path, headers: headers.merge('Authorization' => "Bearer #{access_token.token}")
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

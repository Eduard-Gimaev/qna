require 'rails_helper'

RSpec.describe Api::V1::QuestionsController do
  let(:access_token) { create(:access_token) }
  let(:current_user) { User.find(access_token.resource_owner_id) }
  let(:headers) { { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' } }
  let(:auth_headers) { headers.merge('Authorization' => "Bearer #{access_token.token}") }
  let(:api_path) { "/api/v1/questions/#{question.id}" }
  let!(:questions) { create_list(:question, 3, user: current_user) }
  let(:question) { questions.first }

  describe 'GET api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    it 'returns a list of questions' do
      get api_path, headers: auth_headers
      expect(json_response['questions'].size).to eq 3
    end
  end

  describe 'POST api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:question_attributes) { attributes_for(:question) }
    let(:question_params) { { question: question_attributes }.to_json }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    it 'creates a new question' do
      expect do
        post api_path, params: question_params, headers: auth_headers
      end.to change(Question, :count).by(1)
    end

    it 'returns created status' do
      post api_path, params: question_params, headers: auth_headers
      expect(response).to have_http_status(:created)
    end

    it 'returns attributes of the created question' do
      post api_path, params: question_params, headers: auth_headers
      expect(response).to have_http_status(:created)
      expect(json_response).to have_key('question')
      expect(json_response['question']['title']).to eq question_attributes[:title]
      expect(json_response['question']['body']).to eq question_attributes[:body]
    end
  end

  describe 'GET api/v1/questions/:id' do
    let!(:answers) { create_list(:answer, 2, question: question, user: current_user) }
    let!(:answer) { answers.first }

    before do
      create_list(:comment, 2, commentable: question, user: current_user)
      create_list(:comment, 2, commentable: answer, user: current_user)
      create_list(:link, 2, linkable: question)
      question.files.attach(io: Rails.root.join('spec', 'rails_helper.rb').open, filename: 'rails_helper.rb')
      get api_path, headers: auth_headers
    end

    it 'returns the question' do
      expect(json_response['question']['id']).to eq question.id
    end

    it 'returns all public fields for question' do
      %w[id title body user_id created_at updated_at].each do |attr|
        expect(json_response['question'][attr]).to eq question.send(attr).as_json
      end
    end

    it 'returns comments for the question' do
      expect(json_response['question']['comments'].size).to eq 2
    end

    it 'returns comments for the answer of the question' do
      expect(json_response['question']['answers'].first['comments'].size).to eq 2
    end

    it 'returns the answer of the question' do
      expect(json_response['question']['answers'].size).to eq 2
    end

    it 'returns all public fields for the answer of the question' do
      response_answer = json_response['question']['answers'].detect { |a| a['id'] == answer.id }
      %w[id body user_id created_at updated_at].each do |attr|
        expect(response_answer[attr]).to eq answer.send(attr).as_json
      end
    end

    it 'returns links for the question' do
      expect(json_response['question']['links'].size).to eq 2
    end

    it 'returns attached files as URLs' do
      expect(json_response['question']['files'].first).to include('/rails_helper.rb')
    end
  end

  describe 'PUT api/v1/questions/:id' do
    let(:question_attributes) { attributes_for(:question) }
    let(:question_params) { { question: question_attributes }.to_json }

    it 'returns the updated question' do
      put api_path, params: question_params, headers: auth_headers
      expect(json_response['question']['title']).to eq question_attributes[:title]
      expect(json_response['question']['body']).to eq question_attributes[:body]
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE api/v1/questions/:id' do
    it 'returns no content status' do
      delete api_path, headers: auth_headers
      expect(response).to have_http_status(:no_content)
    end

    it 'deletes the question' do
      expect { delete api_path, headers: auth_headers }.to change(Question, :count).by(-1)
    end
  end
end

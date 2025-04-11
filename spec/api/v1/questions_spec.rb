require 'rails_helper'

RSpec.describe 'Questions API', type: :request do
  let!(:headers) {{ "Content-Type" => "application/json", "ACCEPT" => "application/json" }}
  let!(:api_path) { '/api/v1/questions' }
  let!(:access_token) { create(:access_token) }
  let!(:current_user) { User.find(access_token.resource_owner_id) }
  let!(:questions) { create_list(:question, 3, user: current_user) }
  let!(:question) { questions.first }
  let!(:answers) { create_list(:answer, 2, question:, user: current_user) }
  let!(:answer) { answers.first }
  let!(:question_comments) { create_list(:comment, 2, commentable: question, user: current_user) }
  let!(:answer_comments) { create_list(:comment, 2, commentable: answer, user: current_user) }
  let!(:links) { create_list(:link, 2, linkable: question) }
  let!(:files) {question.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), 
                                      filename: 'rails_helper.rb')}

  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Authorizable' do 
      let(:method) { :get } 
    end 
    
    it 'returns a list of questions' do
      auth_headers = headers.merge("Authorization" => "Bearer #{access_token.token}")
      get api_path, headers: auth_headers
      expect(json_response['questions'].size).to eq 3
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:api_path) { "/api/v1/questions/#{question.id}" }
    before do
      auth_headers = headers.merge("Authorization" => "Bearer #{access_token.token}")
      get api_path, headers: auth_headers
    end

    describe 'question' do
      it 'returns the question' do
        expect(json_response['question']['id']).to eq question.id
      end
      it 'returns all public fields for question' do
        %w[id title body user_id created_at updated_at].each do |attr|
          expect(json_response['question'][attr]).to eq question.send(attr).as_json
        end
      end
    end
    describe 'answer' do
      it 'returns the question answer' do
        expect(json_response['question']['answers'].size).to eq 2
      end
      it 'returns all public fields for answer' do
        response_answer = json_response['question']['answers'].detect { |a| a['id'] == answer.id }
        %w[id body user_id created_at updated_at].each do |attr|
          expect(response_answer[attr]).to eq answer.send(attr).as_json
        end
      end
      it 'returns the question answer comments' do
        expect(json_response['question']['answers'].first['comments'].size).to eq 2
      end
    end

    describe 'comments' do
      it 'returns question comments for the question' do
        expect(json_response['question']['comments'].size).to eq 2
      end

      it 'returns all public fields for comment' do
        comment = question_comments.first
        response_comment = json_response['question']['comments'].detect { |c| c['id'] == comment.id }

        %w[id body user_id created_at updated_at].each do |attr|
          expect(response_comment[attr]).to eq comment.send(attr).as_json
        end
      end
    end

    describe 'links' do
      it 'returns links for the question' do
        expect(json_response['question']['links'].size).to eq 2
      end
    end

    describe 'files' do
      it 'returns attached files as URLs' do
        expect(json_response['question']['files'].first).to include('/rails_helper.rb')
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:question_attributes) { attributes_for(:question) }
    let(:question_params) { { question: question_attributes }.to_json }
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end
    context 'when the user is not authorized' do
      it 'returns unauthorized status' do
        post api_path, params: question_params, headers: headers
        expect(response).to have_http_status(:unauthorized)
      end
      it 'does not create a new question' do
        expect { post api_path, params: question_params, headers: headers
        }.not_to change(Question, :count)
      end
    end

    context 'when the user is authorized' do
      let(:access_token) { create(:access_token) }
      let(:auth_headers) { headers.merge("Authorization" => "Bearer #{access_token.token}") }

      it 'creates a new question' do
        expect { post api_path, params: question_params, headers: auth_headers
          }.to change(Question, :count).by(1)
        end

      it 'returns created status' do
        post api_path, params: question_params, headers: auth_headers
        expect(response).to have_http_status(:created)
      end

      it 'returns the created question' do
        post api_path, params: question_params, headers: auth_headers
        expect(json_response['question']['title']).to eq question_attributes[:title]
        expect(json_response['question']['body']).to eq question_attributes[:body]
      end
    end
  end

  describe 'PUT /api/v1/questions/:id' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :put }
    end
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:access_token) { create(:access_token) }
    let(:current_user) { User.find(access_token.resource_owner_id) } 
    let(:question) { create(:question, user: current_user) } 
    let(:question_attributes) { attributes_for(:question) }
    let(:question_params) { { question: question_attributes }.to_json }
    let(:auth_headers) { headers.merge("Authorization" => "Bearer #{access_token.token}", "Content-Type" => "application/json") }

    it 'returns success status' do
      put api_path, params: question_params, headers: auth_headers
      question.reload
      expect(response).to have_http_status(:ok)
    end
    it 'returns the updated question' do
      put api_path, params: question_params, headers: auth_headers
      expect(json_response['question']['title']).to eq question_attributes[:title]
      expect(json_response['question']['body']).to eq question_attributes[:body]
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end
    let(:access_token) { create(:access_token) }
    let(:current_user) { User.find(access_token.resource_owner_id) } 
    let(:question) { create(:question, user: current_user) } 
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:auth_headers) { headers.merge("Authorization" => "Bearer #{access_token.token}") }

    it 'returns no content status' do
      delete api_path, headers: auth_headers
      expect(response).to have_http_status(:no_content)
    end

    it 'deletes the question' do
      expect { delete api_path, headers: auth_headers }.to change(Question, :count).by(-1)
    end
  end

end
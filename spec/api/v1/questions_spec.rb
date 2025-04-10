require 'rails_helper'

RSpec.describe 'Questions API', type: :request do
  let(:headers) {{ "Content-Type" => "application/json", "ACCEPT" => "application/json" }}
  let!(:api_path) { '/api/v1/questions' }

  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Authorizable' do 
      let(:method) { :get } 
    end 

    let(:access_token) { create(:access_token) }
    let!(:user) { create(:user) }
    let!(:questions) { create_list(:question, 3) }
    let!(:question) { questions.first }
    let!(:answers) { create_list(:answer, 3, question:) }
    let!(:answer) { answers.first }
    let(:question_response) { json_response['questions'].first }

    before do
      auth_headers = headers.merge("Authorization" => "Bearer #{access_token.token}")
      get api_path, headers: auth_headers
    end

    it 'returns successful status if access token is valid' do
      expect(response).to be_successful
    end
    it 'returns a list of questions' do
      expect(json_response['questions'].size).to eq 3
    end
    it 'returns all public fields of the question' do
      %w[id title body created_at updated_at].each do |attr|
        expect(question_response[attr]).to eq question.send(attr).as_json
      end
    end

    it 'contains the user_id of the question' do
      expect(question_response['user_id']).to eq question.user_id
    end

    it 'contains a shortened version of the title' do
      expect(question_response['short_title']).to eq question.title.truncate(9)
    end

    describe 'answers' do
      let(:answer) { answers.first }
      let(:answer_response) { question_response['answers'].first }

      it 'returns a list of answers for each question' do
        expect(question_response['answers'].size).to eq 3
      end

      it 'returns all public fields of the answer' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answers.first.send(attr).as_json
        end
      end
    end

    describe 'comments' do
      let(:question_comments) { create_list(:comment, 3, commentable: question, user: user) }
      let(:answer_comments) { create_list(:comment, 3, commentable: answer, user: user) }

      before do
        auth_headers = headers.merge("Authorization" => "Bearer #{access_token.token}")
        get api_path, headers: auth_headers
      end

      it 'returns a list of comments for each question' do

      end
    end


    # describe 'file attachments' do
    #   let(:file_response) { question_response['file_attachments'].first }

    #   it 'returns a list of file attachments for each question' do
    #     expect(question_response['file_attachments'].size).to eq 2
    #   end

    #   it 'returns the file url' do
    #     expect(file_response['file_url']).to eq file_attachments.first.file.url
    #   end
    # end

    # describe 'links' do
    #   let(:link_response) { question_response['links'].first }

    #   it 'returns a list of links for each question' do
    #     expect(question_response['links'].size).to eq 2
    #   end

    #   it 'returns the url and title of the link' do
    #     expect(link_response['url']).to eq links.first.url
    #     expect(link_response['title']).to eq links.first.title
    #   end
    # end
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
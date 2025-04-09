require 'rails_helper'

RSpec.describe 'Questions API', type: :request do
  let(:headers) {{ "Content-Type" => "application/json", "ACCEPT" => "application/json" }}

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authorizable' do 
      let(:method) { :get }
    end

    context 'when the user is authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 3) }
      let(:question) { questions.first }
      let!(:answers) { create_list(:answer, 3, question:) }
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
        let!(:answer) { answers.first }
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
      
    end
  end
end
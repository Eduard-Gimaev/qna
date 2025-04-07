require 'rails_helper'

RSpec.describe 'Profile API', type: :request do
  let(:headers) {{ "Content-Type" => "application/json", "ACCEPT" => "application/json" }}

  describe 'GET /api/v1/profile/me' do
    context 'when the user is not authorized' do
      it 'returns a 401 Unauthorized' do
        get '/api/v1/profiles/me', headers: headers
        expect(response.status).to eq 401
      end
      it 'returns a status code of 401 if access token is not valid' do
        get '/api/v1/profiles/me', params: { access_token: 'invalid_token' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'when the user is authorized' do
      let(:access_token) { create(:access_token)}

      it 'returns a status code of successful if access token is valid' do
        auth_headers = headers.merge("Authorization" => "Bearer #{access_token.token}")
        get '/api/v1/profiles/me', headers: auth_headers
        puts "Response status: #{response.status}"
        puts "Response body: #{response.body}"
        expect(response).to be_successful
      end
    end
  end
end
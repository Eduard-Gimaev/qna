require 'rails_helper'

RSpec.describe 'Profiles API', type: :request do
  let(:headers) {{ "Content-Type" => "application/json", "ACCEPT" => "application/json" }}

  describe 'GET /api/v1/profiles/me' do
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
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        auth_headers = headers.merge("Authorization" => "Bearer #{access_token.token}")
        get '/api/v1/profiles/me', headers: auth_headers
      end

      it 'returns successful status if access token is valid' do
        expect(response).to be_successful
      end

      it 'returns all public fields of the user' do
        %w[id email created_at updated_at admin].each do |attr|
          expect(json_response[attr]).to eq me.send(attr).as_json
        end
      end
      it 'does not return private fields of the user' do
        %w[password encrypted_password].each do |attr|
          expect(json_response[attr]).to be_nil
        end
      end
    end
  end
end
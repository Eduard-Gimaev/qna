require 'rails_helper'

RSpec.describe Api::V1::ProfilesController do
  let(:headers) { { 'Content-Type' => 'application/json', 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'when the user is authorized' do
      let!(:me) { create(:user) }
      let!(:other_users) { create_list(:user, 3) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        auth_headers = headers.merge('Authorization' => "Bearer #{access_token.token}")
        get '/api/v1/profiles/me', headers: auth_headers
      end

      it 'returns successful status if access token is valid' do
        expect(response).to be_successful
      end

      it 'returns all public fields of the user' do
        %w[id email created_at updated_at admin].each do |attr|
          expect(json_response['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields of the user' do
        %w[password encrypted_password].each do |attr|
          expect(json_response['user'][attr]).to be_nil
        end
      end

      it 'returns list of users excluding the current one' do
        auth_headers = headers.merge('Authorization' => "Bearer #{access_token.token}")
        get '/api/v1/profiles', headers: auth_headers
        expect(json_response['users'].size).to eq 3
        ids = json_response['users'].map { |user| user['id'] }
        expect(ids).not_to include(me.id)
      end
    end
  end
end

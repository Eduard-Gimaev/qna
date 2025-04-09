shared_examples_for 'API Authorizable' do
  context 'when the user is not authorized' do
    it 'returns a 401 Unauthorized' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end
    it 'returns a status code of 401 if access token is not valid' do
      do_request(method, api_path, params: { access_token: 'invalid_token' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end
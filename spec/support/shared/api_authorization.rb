shared_examples_for 'API Authorizable' do
  context 'when the user is not authorized' do
    it 'returns 401 Unauthorized if no token' do
      do_request(method, api_path, headers: headers)
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 Unauthorized if token is invalid' do
      bad_headers = headers.merge('Authorization' => 'Bearer invalid_token')
      do_request(method, api_path, headers: bad_headers, params: {}.to_json)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

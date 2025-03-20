require 'rails_helper'

RSpec.describe OauthCallbacksController do
  subject(:controller_instance) { controller }

  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'Github' do
    let(:oauth_data) { OmniAuth::AuthHash.new(provider: 'github', 'uid' => '123') }

    it 'finds user from oauth data' do
      request.env['omniauth.auth'] = oauth_data
      allow(Services::FindForOauth).to receive(:new).with(oauth_data).and_return(instance_double(Services::FindForOauth, call: nil))
      get :github
      expect(Services::FindForOauth).to have_received(:new).with(oauth_data)
    end

    context 'when user exists' do
      let!(:user) { create(:user) }

      before do
        allow(Services::FindForOauth).to receive(:new).with(oauth_data).and_return(instance_double(Services::FindForOauth, call: user))
        request.env['omniauth.auth'] = oauth_data
        get :github
      end

      it 'logs in user' do
        expect(controller_instance.current_user).to eq user
      end

      it 'redirects to root' do
        expect(response).to redirect_to root_path
      end
    end

    context 'when user does not exist' do
      before do
        allow(Services::FindForOauth).to receive(:new).with(oauth_data).and_return(instance_double(Services::FindForOauth, call: nil))
        request.env['omniauth.auth'] = oauth_data
        get :github
      end

      it 'does not log in user' do
        expect(controller_instance.current_user).to be_nil
      end

      it 'redirects to root' do
        expect(response).to redirect_to root_path
      end
    end
  end
end

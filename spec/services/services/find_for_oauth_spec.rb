require 'rails_helper'

RSpec.describe Services::FindForOauth do
  subject(:service) { described_class.new(auth) }

  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

  context 'when user already has an authorization' do
    it 'returns the user' do
      user.authorizations.create(provider: 'facebook',
                                 uid: '123456')
      expect(service.call).to eq user
    end
  end

  context 'when user has no authorization' do
    context 'when user already exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

      it 'does not create a new user' do
        expect { service.call }.not_to change(User, :count)
      end

      it 'creates authorization for user' do
        expect { service.call }.to change(user.authorizations, :count).by(1)
      end

      it 'creates authorization with provider and uid' do
        authorization = service.call.authorizations.first
        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end

    context 'when user does not exist' do
      let(:auth) do
        OmniAuth::AuthHash.new(provider: 'facebook',
                               uid: '123456',
                               info: { email: 'new@user.com' })
      end

      it 'creates a new user' do
        expect { service.call }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(service.call).to be_a(User)
      end

      it 'creates authorization for user' do
        user = service.call
        expect(user.authorizations
                    .where(provider: auth.provider, uid: auth.uid)
                    .count).to eq 1
      end

      it 'creates authorization with provider and uid' do
        authorization = service.call.authorizations.first
        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
  end
end

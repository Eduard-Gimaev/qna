require 'rails_helper'

RSpec.describe User do
  let(:user_first) { create(:user) }
  let(:question_first) { create(:question, user: user_first) }
  let(:answer_first) { create(:answer, question: question_first, user: user_first) }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to have_many(:questions).dependent(true) }
  it { is_expected.to have_many(:answers).dependent(true) }

  it 'has a correct author for an answer' do
    expect(user_first).to be_author(answer_first)
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'when user already has an authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook',
                                   uid: '123456')
        expect(described_class.find_for_oauth(auth)).to eq user
      end
    end

    context 'when user has no authorization' do
      context 'when user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', info: { email: user.email }) }

        it 'does not create a new user' do
          expect { described_class.find_for_oauth(auth) }.not_to change(described_class, :count)
        end

        it 'creates authorization for user' do
          expect { described_class.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = described_class.find_for_oauth(auth).authorizations.first
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
          expect { described_class.find_for_oauth(auth) }.to change(described_class, :count).by(1)
        end

        it 'returns new user' do
          expect(described_class.find_for_oauth(auth)).to be_a(described_class)
        end

        it 'creates authorization for user' do
          user = described_class.find_for_oauth(auth)
          expect(user.authorizations
                     .where(provider: auth.provider, uid: auth.uid)
                     .count).to eq 1
        end

        it 'creates authorization with provider and uid' do
          authorization = described_class.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end

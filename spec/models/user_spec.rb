require 'rails_helper'

RSpec.describe User do
  let(:user_first) { create(:user) }
  let(:question_first) { create(:question, user: user_first) }
  let(:answer_first) { create(:answer, question: question_first, user: user_first) }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to have_many(:questions).dependent(true) }
  it { is_expected.to have_many(:answers).dependent(true) }
  it { is_expected.to have_many(:authorizations).dependent(true) }

  it 'has a correct author for an answer' do
    expect(user_first).to be_author(answer_first)
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauth') }

    it 'calls FindForOauth' do
      allow(FindForOauth).to receive(:new).with(auth).and_return(service)
      allow(service).to receive(:call)
      described_class.find_for_oauth(auth)
      expect(service).to have_received(:call)
      expect(FindForOauth).to have_received(:new).with(auth)
    end
  end
end

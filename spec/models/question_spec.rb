# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question do
  it_behaves_like 'votable'

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:body) }

  it { is_expected.to have_many(:answers).dependent(true) }
  it { is_expected.to have_many(:links).dependent(true) }
  it { is_expected.to have_one(:reward).dependent(true) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to have_many_attached(:files) }

  it { is_expected.to accept_nested_attributes_for(:links) }
  it { is_expected.to accept_nested_attributes_for(:reward) }

  describe 'Question' do
    let(:question) { build(:question) }

    it 'calls CalculateReputationJob' do
      allow(CalculateReputationJob).to receive(:perform_later).with(question)
      question.save
      expect(CalculateReputationJob).to have_received(:perform_later).with(question)
    end
  end
end

require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  let(:question) { create(:question) }

  describe '#perform' do
    it 'calls Services::Reputation#calculate' do
      expect(Services::Reputation).to receive(:calculate).with(question)
      described_class.perform_now(question)
    end

    it 'does not call Services::Reputation#calculate for other users' do
      expect(Services::Reputation).not_to receive(:calculate).with(user)
      described_class.perform_now(user)
    end
  end
end
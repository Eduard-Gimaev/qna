require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  let(:question) { create(:question) }

  describe '#perform' do
    it 'calls Services::Reputation#calculate' do
      expect(Services::Reputation).to receive(:calculate).with(question)
      described_class.perform_now(question)
    end
    
  end
end
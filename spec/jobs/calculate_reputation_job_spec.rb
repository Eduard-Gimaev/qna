require 'rails_helper'

RSpec.describe CalculateReputationJob do
  let(:question) { create(:question) }

  it 'calls CalculateReputation service' do
    service = instance_double(CalculateReputation)
    allow(CalculateReputation).to receive(:call).with(question).and_return(service)

    described_class.perform_now(question)

    expect(CalculateReputation).to have_received(:call).with(question)
  end
end

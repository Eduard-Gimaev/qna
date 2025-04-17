require 'rails_helper'

RSpec.describe ReputationJob do
  let(:question) { create(:question) }

  it 'calls Reputation service' do
    service = instance_double(Services::Reputation)
    allow(Services::Reputation).to receive(:calculate).with(question).and_return(service)

    described_class.perform_now(question)

    expect(Services::Reputation).to have_received(:calculate).with(question)
  end
end

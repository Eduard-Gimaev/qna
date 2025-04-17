require 'rails_helper'

RSpec.describe SendDailyDigestJob do
  it 'calls SendDailyDigest service' do
    allow(SendDailyDigest).to receive(:call)

    described_class.perform_now

    expect(SendDailyDigest).to have_received(:call)
  end
end

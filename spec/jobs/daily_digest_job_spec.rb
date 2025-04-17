require 'rails_helper'

RSpec.describe DailyDigestJob do
  it 'calls DailyDigest service' do
    service = instance_double(Services::DailyDigest)
    allow(Services::DailyDigest).to receive(:new).and_return(service)
    allow(service).to receive(:send_daily_digest)

    described_class.perform_now

    expect(service).to have_received(:send_daily_digest)
  end
end

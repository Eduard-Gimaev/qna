require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:service){ instance_double(Services::DailyDigest) }
  let(:user) { create(:user) }

  before do
    allow(Services::DailyDigest).to receive(:new).and_return(service)
  end

  it 'calls Services::DailyDigest#send_daily_digest' do
    expect(service).to receive(:send_daily_digest)
    described_class.perform_now
  end
end

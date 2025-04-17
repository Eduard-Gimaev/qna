require 'rails_helper'

RSpec.describe Services::DailyDigest do
  subject(:daily_digest_service) { described_class.new }

  let!(:users) { create_list(:user, 3) }

  before do
    allow(DailyDigestMailer).to receive(:digest).and_call_original
  end

  it 'sends daily digest emails to all users' do
    create(:question, user: users.first, created_at: 1.day.ago)
    daily_digest_service.send_daily_digest

    users.each do |user|
      expect(DailyDigestMailer).to have_received(:digest).with(user)
    end
  end

  it 'does not send emails if there are no new questions' do
    daily_digest_service.send_daily_digest

    users.each do |user|
      expect(DailyDigestMailer).not_to have_received(:digest).with(user)
    end
  end
end

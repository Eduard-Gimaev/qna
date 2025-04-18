require 'rails_helper'

RSpec.describe SendDailyDigest do
  let!(:users) { create_list(:user, 3) }

  before do
    allow(DailyDigestMailer).to receive(:digest).and_call_original
  end

  it 'sends daily digest emails to all users' do
    create(:question, user: users.first, created_at: 1.day.ago)
    described_class.call

    users.each do |user|
      expect(DailyDigestMailer).to have_received(:digest).with(user)
    end
  end

  it 'does not send emails if there are no new questions' do
    described_class.call

    users.each do |user|
      expect(DailyDigestMailer).not_to have_received(:digest).with(user)
    end
  end
end

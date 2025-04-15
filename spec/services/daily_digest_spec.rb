require 'rails_helper'

RSpec.describe Services::DailyDigest do
  let!(:users) { create_list(:user, 3) }
  
  it 'sends daily digest emails to all users' do
    create(:question, user: users.first, created_at: 1.day.ago)
    users.each do |user| 
      expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original 
    end

    subject.send_daily_digest
  end

  it ' does not send emails if there are no new questions' do
    users.each do |user| 
      expect(DailyDigestMailer).not_to receive(:digest).with(user) 
    end

    subject.send_daily_digest
  end
end
require 'rails_helper'

RSpec.describe DailyDigestMailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let!(:recent_question) { create(:question, created_at: 1.hour.ago, title: 'Recent Question') }
    let!(:old_question) { create(:question, created_at: 2.days.ago, title: 'Old Question') }

    let(:mail) { described_class.digest(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Daily Digest')
      expect(mail.to).to eq([user.email])
    end

    context 'when there are recent questions' do
      it 'includes recent questions in the HTML body' do
        expect(mail.html_part.body.decoded).to include('Recent Question')
      end
    end

    context 'when there are old questions' do
      it 'does not include old questions in the HTML body' do
        expect(mail.html_part.body.decoded).not_to include('Old Question')
      end
    end
  end
end

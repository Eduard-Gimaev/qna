require 'rails_helper'

RSpec.describe NotifySubscribers do
  include ActiveJob::TestHelper

  let(:question) { create(:question) }
  let(:author) { create(:user) }
  let(:subscriber) { create(:user) }
  let(:answer) { create(:answer, question: question, user: author) }

  before do
    ActionMailer::Base.deliveries.clear
  end

  it 'sends email to subscribers except the author of the answer' do
    question.subscriptions.create!(user: subscriber)
    perform_enqueued_jobs do
      expect do
        described_class.new(answer).call
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to include(subscriber.email)
    expect(mail.subject).to eq('New answer to your question')
  end

  it 'does not send email to the author of the answer' do
    question.subscriptions.create!(user: author)
    perform_enqueued_jobs do
      expect do
        described_class.new(answer).call
      end.not_to(change { ActionMailer::Base.deliveries.count })
    end
  end
end

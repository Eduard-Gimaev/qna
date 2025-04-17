require 'rails_helper'

RSpec.describe QuestionAnsweredNotificationJob do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  it 'sends notification email to question author' do
    mailer = instance_double(ActionMailer::MessageDelivery)
    allow(QuestionAnsweredMailer).to receive(:question_answered).with(question, answer).and_return(mailer)
    allow(mailer).to receive(:deliver_now)

    described_class.perform_now(question, answer)

    expect(QuestionAnsweredMailer).to have_received(:question_answered).with(question, answer)
    expect(mailer).to have_received(:deliver_now)
  end
end

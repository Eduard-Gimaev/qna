require 'rails_helper'

RSpec.describe QuestionAnsweredNotificationJob do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  it 'sends notification email to question author' do
    allow(QuestionAnsweredMailer).to receive_message_chain(:question_answered, :deliver_later)

    described_class.perform_now(question, answer)

    expect(QuestionAnsweredMailer).to have_received(:question_answered).with(question, answer)
    expect(QuestionAnsweredMailer.question_answered(question, answer)).to have_received(:deliver_later)
  end
end

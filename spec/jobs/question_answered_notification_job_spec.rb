require 'rails_helper'

RSpec.describe QuestionAnsweredNotificationJob, type: :job do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  it 'sends notification to the question author' do
    expect(QuestionAnsweredMailer).to receive(:question_answered).with(question, answer).and_call_original
    described_class.perform_now(question, answer)
  end
end
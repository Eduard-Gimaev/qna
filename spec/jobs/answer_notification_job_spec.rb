require 'rails_helper'

RSpec.describe AnswerNotificationJob, type: :job do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  it 'sends notification to the question subscribers' do
    expect(Services::NotifySubscribers).to receive(:new).with(answer).and_call_original
    expect_any_instance_of(Services::NotifySubscribers).to receive(:call)

    AnswerNotificationJob.perform_now(answer)
  end
end

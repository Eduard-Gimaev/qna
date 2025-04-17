require 'rails_helper'

RSpec.describe AnswerNotificationJob do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  it 'sends notification to the question subscribers' do
    service = instance_double(Services::NotifySubscribers)
    allow(Services::NotifySubscribers).to receive(:new).with(answer).and_return(service)
    allow(service).to receive(:call)

    described_class.perform_now(answer)
    expect(Services::NotifySubscribers).to have_received(:new).with(answer)
    expect(service).to have_received(:call)
  end
end

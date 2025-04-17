require 'rails_helper'

RSpec.describe AnswerNotificationJob do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:service) { instance_double(NotifySubscribers) }

  before do
    allow(NotifySubscribers).to receive(:new).with(answer).and_return(service)
    allow(service).to receive(:call)
  end

  it 'sends notification to the question subscribers' do
    described_class.perform_now(answer)
    expect(NotifySubscribers).to have_received(:new).with(answer)
    expect(service).to have_received(:call)
  end
end

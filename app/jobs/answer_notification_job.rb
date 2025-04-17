class AnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NotifySubscribers.new(answer).call
  end
end

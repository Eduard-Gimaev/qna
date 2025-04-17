class AnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::NotifySubscribers.new(answer).call
  end
end

class QuestionAnsweredNotificationJob < ApplicationJob
  queue_as :default

  def perform(question, answer)
    QuestionAnsweredMailer.question_answered(question, answer).deliver_now
  end
end

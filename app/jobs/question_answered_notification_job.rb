class QuestionAnsweredNotificationJob < ApplicationJob
  queue_as :default

  def perform(question, answer)
    QuestionAnsweredMailer.question_answered(question, answer).deliver_later
  end
end

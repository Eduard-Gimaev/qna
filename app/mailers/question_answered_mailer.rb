class QuestionAnsweredMailer < ApplicationMailer
  def question_answered(question, answer)
    @question = question
    @answer = answer

    mail(to: @question.user.email, subject: I18n.t('mailers.question_answered_mailer.new_answer_subject'))
  end
end

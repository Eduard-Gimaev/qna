class QuestionAnsweredMailer < ApplicationMailer
  def question_answered(question, answer)
    @question = question
    @answer = answer

    mail(to:  @question.user.email, subject: "Your question has received a new answer")
  end
end
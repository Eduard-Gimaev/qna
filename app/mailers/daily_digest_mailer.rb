class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where(created_at: 1.day.ago.beginning_of_day..Time.current)
    mail(to: user.email, subject: "Daily Digest")
  end
end

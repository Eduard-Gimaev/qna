class SubscriptionMailer < ApplicationMailer
  def subscription(subscription)
    @subscription = subscription
    @question = subscription.question
    @user = subscription.user

    mail(to: @user.email, subject: "You have subscribed to #{@question.title}")
  end

  def unsubscribe(subscription)
    @subscription = subscription
    @question = subscription.question
    @user = subscription.user

    mail(to: @user.email, subject: "You have unsubscribed from #{@question.title}")
  end

  def new_answer(user, question, answer)
    @user = user
    @question = question
    @answer = answer

    mail(to: @user.email, subject: I18n.t('mailers.subscription_mailer.new_answer_subject'))
  end
end

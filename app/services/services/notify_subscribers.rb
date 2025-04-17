class Services::NotifySubscribers
  def initialize(answer)
    @question = answer.question
    @answer = answer
  end

  def call
    @question.subscriptions.includes(:user).each do |subscription|
      user = subscription.user
      next if user == @answer.user || user.id == @answer.user_id

      SubscriptionMailer.new_answer(user, @question, @answer).deliver_later
    end
  end
end

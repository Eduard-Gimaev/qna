class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create]

  def create
    @subscription = current_user.subscriptions.build(question: @question)
    authorize @subscription

    if @subscription.save
      SubscriptionMailer.subscription(@subscription).deliver_later
      flash[:notice] = "You have subscribed to #{@question.title}"
    end

    redirect_to @question
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    authorize @subscription
    @question = @subscription.question
    @user = @subscription.user

    @subscription&.destroy
    if @subscription.destroyed?
      SubscriptionMailer.unsubscribe(@user, @question).deliver_later
      flash[:notice] = "You have unsubscribed from #{@question.title}"
    end
    redirect_to @question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end

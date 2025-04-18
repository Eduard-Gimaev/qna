# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: %i[update mark_as_best destroy]
  before_action :authorize_answer!
  after_action :publish_answer, only: :create
  after_action :verify_authorized

  def new
    @answer = @question.answers.new
  end

  def edit; end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      QuestionAnsweredNotificationJob.perform_later(@question, @answer)
      AnswerNotificationJob.perform_later(@question, @answer)
      redirect_to @question, notice: I18n.t('controllers.answers.success_notice')
    else
      render :new
    end
  end

  def update
    @answer.update(answer_params) if current_user.author?(@answer)
    @question = @answer.question
  end

  def mark_as_best
    return unless current_user.author?(@answer.question)

    @answer.mark_as_best
    @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.author?(@answer)
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "question_#{@question.id}_answers",
      render_to_string(
        partial: 'answers/answer',
        locals: { answer: @answer }
      )
    )
  end

  def find_question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                          links_attributes: %i[name url]).merge(user_id: current_user.id)
  end

  def authorize_answer!
    @answer ||= Answer.new
    authorize(@answer)
  end
end

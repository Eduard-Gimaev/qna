# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: %i[update mark_as_best destroy]

  def new
    @answer = @question.answers.new
  end

  def edit; end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.save
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
end

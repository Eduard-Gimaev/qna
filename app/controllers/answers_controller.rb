class AnswersController < ApplicationController
  before_action :authenticate_user!
  
  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: %i[update destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params.merge( user_id: current_user.id))  
    @answer.save
  end

  def update 
    @answer.update(answer_params) if current_user.author?(@answer)
    @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.author?(@answer)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body).merge(user_id: current_user.id)
  end
end
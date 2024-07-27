class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: %i[destroy]


  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params.merge( user_id: current_user.id))  
    if @answer.save
      redirect_to question_path(@question), notice: 'Your answer successfully created.'
    else
      render :new
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Answer successfully deleted.'
    else
      redirect_to question_path(@answer.question), notice: 'You have no rigths to delete this answer.'
    end
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

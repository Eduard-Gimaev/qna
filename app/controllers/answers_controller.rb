class AnswersController < ApplicationController

  def index
    @question = Question.find(params[:id])
    @answers = Answer.all
  end
end

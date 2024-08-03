class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def show
    find_question 
    @answer = Answer.new
    @answers = @question.answers.sort_by_best.order(:id)
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    find_question.update(question_params) if current_user.author?(@question)
  end

  def destroy
    if current_user.author?(find_question)
      @question.destroy
      redirect_to questions_path, notice: 'Question successfully deleted.'
    else
      redirect_to questions_path, notice: 'You have no rigths to delete this question.'
    end
  end

  private

  def find_question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :find_question

  def question_params
    params.require(:question).permit(:title, :body).merge(user_id: current_user.id)
  end

end

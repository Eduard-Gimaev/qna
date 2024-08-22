# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show update]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answers = @question.answers.sort_by_best.order(:id)
  end

  def new
    @question = Question.new
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def update
    find_question.update(question_params) if current_user.author?(@question)
  end

  def destroy
    @question.destroy if current_user.author?(find_question)
    redirect_to questions_path
  end

  private

  # rubocop:disable Naming/MemoizedInstanceVariableName
  def find_question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :find_question
  # rubocop:enable Naming/MemoizedInstanceVariableName

  def question_params
    params.require(:question).permit(:title, :body, files: []).merge(user_id: current_user.id)
  end
end

# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :find_question, only: %i[show edit update]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answers = @question.answers.sort_by_best.order(:id)
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
  end

  def edit; end

  def create
    @question = Question.new(question_params)
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
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: %i[name url _destroy],
                                                    reward_attributes: %i[title image]).merge(user_id: current_user.id)
  end
end

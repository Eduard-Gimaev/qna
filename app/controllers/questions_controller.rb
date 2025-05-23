# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :find_question, only: %i[show edit update]
  before_action :authorize_question!
  after_action :publish_question, only: %i[create]
  after_action :verify_authorized

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answers = @question.answers.sort_by_best.order(:id)
    @answer.links.new
    @subscription = @question.subscriptions.find_by(user: current_user)
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

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      render_to_string(
        partial: 'questions/question',
        locals: { question: @question, current_user: current_user, table_headers: true }
      )
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: %i[name url _destroy],
                                                    reward_attributes: %i[title image]).merge(user_id: current_user.id)
  end

  def authorize_question!
    authorize(find_question)
  end
end

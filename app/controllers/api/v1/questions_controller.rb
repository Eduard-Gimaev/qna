class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: %i[update destroy show]

  def index
    questions = Question.includes(:answers, :comments).all
    render json: questions, include: ['answers', 'comments', 'answers.comments']
  end

  def show
    render json: @question, include: ['comments', 'answers', 'links', 'answers.comments']
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      render json: @question, status: :created
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question, status: :ok
    else
      render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @question.destroy
      head :no_content
    else
      render json: { errors: 'Unable to delete the question' }, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def find_question
    @question = current_resource_owner.questions.includes(:comments, answers: :comments).find(params[:id])
  end
end

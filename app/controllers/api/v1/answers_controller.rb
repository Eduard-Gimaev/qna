class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_answer, only: %i[update destroy show]
  before_action :find_question, only: %i[create index]

  def index
    answers = @question.answers.includes(:user, :comments, :links, :files)
    render json: @answers, each_serializer: AnswerSerializer
  end

  def show
    render json: @answer, serializer: AnswerSerializer
  end

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      render json: @answer, status: :created, serializer: AnswerSerializer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def update
    if @answer.update(answer_params)
      render json: @answer, status: :ok, serializer: AnswerSerializer
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def destroy 
    if @answer.destroy
      head :no_content
    else
      render json: { errors: 'Unable to delete the answer' }, status: :unprocessable_entity
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :best).merge(user: current_resource_owner)
  end

  def find_question
    @question = Question.find(params[:question_id]) 
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Question not found' }, status: :not_found
  end

  def find_answer
    @answer = Answer.includes(:comments, :links, files_attachments: :blob).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Answer not found' }, status: :not_found
  end

end
module Commented
  extend ActiveSupport::Concern

  included do
    before_action :find_commentable, only: %i[create_comment destroy_comment]
    before_action :find_comment, only: %i[destroy_comment]
  end

  def create_comment
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, notice: 'Comment was successfully created.'
    else
      redirect_to @commentable, alert: 'Failed to create comment.'
    end
  end

  def destroy_comment
    if current_user.author?(@comment)
      @comment.destroy
      redirect_to @comment.commentable, notice: 'Comment was successfully deleted.'
    else
      redirect_to @comment.commentable, alert: 'You are not the author of the comment.'
    end
  end

  private

  def find_commentable
    @commentable = if params[:question_id]
                     Question.find(params[:question_id])
                   elsif params[:answer_id]
                     Answer.find(params[:answer_id])
                   end
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
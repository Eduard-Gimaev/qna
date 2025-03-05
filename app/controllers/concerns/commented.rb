module Commented
  extend ActiveSupport::Concern

  def create_comment
    @commentable = if params[:question_id]
                     Question.find(params[:question_id])
                   elsif params[:answer_id]
                     Answer.find(params[:answer_id])
                   end
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
    redirect_to @commentable.is_a?(Question) ? @commentable : @commentable.question
  end

  def destroy_comment
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to @comment.commentable if current_user.author?(@comment)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end

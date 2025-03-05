module Commented
  extend ActiveSupport::Concern

  def create_comment
    @commentable = if params[:question_id]
                     Question.find(params[:question_id])
                   elsif params[:answer_id]
                     Answer.find(params[:answer_id])
                   end
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable.is_a?(Question) ? @commentable : @commentable.question
    else
      redirect_to @commentable.is_a?(Question) ? @commentable : @commentable.question
    end
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
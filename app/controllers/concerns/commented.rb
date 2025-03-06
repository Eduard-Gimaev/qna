module Commented
  extend ActiveSupport::Concern

  def create_comment
    @commentable = if params[:question_id]
                     Question.find(params[:question_id])
                   elsif params[:answer_id]
                     Answer.find(params[:answer_id])
                   end
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
    if @comment.persisted?
      ActionCable.server.broadcast(
         "comments_#{@commentable.is_a?(Answer) ? @commentable.question.id : @commentable.id}_channel",
        render_to_string(
          partial: 'comments/comment',
          locals: { comment: @comment}
        )
      )
      redirect_to @commentable.is_a?(Question) ? @commentable : @commentable.question, notice: 'Comment was successfully created.'
    else
      redirect_to @commentable.is_a?(Question) ? @commentable : @commentable.question, alert: 'Failed to create comment.'
    end
  end 

  def destroy_comment
    @comment = Comment.find(params[:id])
    if current_user.author?(@comment)
      @comment.destroy
      redirect_to @comment.commentable.is_a?(Question) ? @comment.commentable : @comment.commentable.question
    else
      redirect_to @comment.commentable.is_a?(Question) ? @comment.commentable : @comment.commentable.question
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end

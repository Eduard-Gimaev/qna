class CommentsController < ApplicationController
  before_action :set_commentable, only: :create

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      ActionCable.server.broadcast "comments_#{@commentable.id}_channel",
                                   render_to_string(partial: 'comments/comment', locals: { comment: @comment })

    end
    redirect_to @comment.commentable.is_a?(Question) ? @comment.commentable : @comment.commentable.question
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy if current_user.author?(@comment)
    redirect_to @comment.commentable.is_a?(Question) ? @comment.commentable : @comment.commentable.question
  end

  private

  def set_commentable
    @commentable = if params[:question_id]
                     Question.find(params[:question_id])
                   elsif params[:answer_id]
                     Answer.find(params[:answer_id])
                   end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end

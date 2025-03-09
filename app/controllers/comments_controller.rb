class CommentsController < ApplicationController
  before_action :set_commentable, only: :create

  def create
    @comment = @commentable.comments.create(comment_params)
    publish_comment(@comment) if @comment.persisted?
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

  def publish_comment(comment)
    case comment.commentable
    when Question
      channel = "question_comments_#{params[:question_id]}_channel"
      data = { comment: comment, question_id: comment.commentable.id }
    when Answer
      channel = "answer_#{params[:answer_id]}_comment_channel"
      data = { comment: comment, answer_id: comment.commentable.id }
    end
    ActionCable.server.broadcast(channel, data)
  end

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end
end

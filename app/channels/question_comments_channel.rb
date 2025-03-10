class QuestionCommentsChannel < ApplicationCable::Channel
  def subscribed
    channel = "question_comments_#{params[:question_id]}_channel"

    stream_from channel
  end
end

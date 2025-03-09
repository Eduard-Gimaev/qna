class AnswerCommentsChannel < ApplicationCable::Channel
  def subscribed
    channel = "answer_#{params[:answer_id]}_comment_channel"
    stream_from channel
  end
end
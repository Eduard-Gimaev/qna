class CommentsChannel < ApplicationCable::Channel
  def subscribed
    question_id = params['question_id']
    stream_from "comments_#{question_id}_channel" if question_id.present?
  end
end
class CommentsChannel < ApplicationCable::Channel
  def subscribed
    if params['question_id'].present?
      question_id = params['question_id']
      stream_from "comments_#{question_id}_channel"
    elsif params['answer_id'].present?
      answer_id = params['answer_id']
      stream_from "comments_#{answer_id}_channel"
    end
  end
end

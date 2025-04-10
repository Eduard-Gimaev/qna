class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :created_at, :updated_at, :short_title

  has_many :answers
  # has_many :attachments
  # has_many :links
  has_many :comments
  # attribute :comments_count do
  #   object.comments.count
  # end

  def short_title
    object.title.truncate(9)
  end
end

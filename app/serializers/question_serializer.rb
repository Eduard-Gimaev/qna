class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :user_id, :short_title

  has_many :answers
  has_many :comments
  has_many :links
  attribute :files

  def short_title
    object.title.truncate(9)
  end

  def files
    object.files.map { |file| Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true) }
  end
end

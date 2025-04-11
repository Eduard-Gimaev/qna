class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :user_id

  has_many :comments
  has_many :links

  attribute :files

  def files
    object.files.map { |file| Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true) }
  end
end

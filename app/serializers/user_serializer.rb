class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :created_at, :updated_at, :admin

  has_many :questions
  has_many :answers
end
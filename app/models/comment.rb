class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true, length: { minimum: 5 }
  validates :user, presence: true
  validates :commentable, presence: true
end

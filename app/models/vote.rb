class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  enum vote_type: { like: 1, dislike: -1 }

  validates :user_id, uniqueness: { scope: %i[votable_id votable_type] }
end

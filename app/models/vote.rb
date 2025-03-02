class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  enum vote_type: { like: 1, dislike: -1 }

  # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :user_id, uniqueness: { scope: %i[votable_id votable_type] }
  # rubocop:enable Rails/UniqueValidationWithoutIndex
end

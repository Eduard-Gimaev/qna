class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :user_id, uniqueness: { scope: %i[votable_id vote_value] }
  # rubocop:enable Rails/UniqueValidationWithoutIndex
end

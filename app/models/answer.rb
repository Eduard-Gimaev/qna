# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable
  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def mark_as_best
    # rubocop:disable Rails::SkipsModelValidations
    transaction do
      self.class.where(question_id:).update_all(best: false)
      update!(best: true)
      if self.question.reward
        Reward.where(question_id: self.question_id).update_all(user_id: nil)
        self.question.reward.update(user_id: self.user.id)
      end
    end
    # rubocop:enable Rails::SkipsModelValidations
  end
end

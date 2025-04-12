class AnswerPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def update?
    user.author?(record)
  end

  def destroy?
    user.author?(record)
  end

  def mark_as_best?
    user.author?(record.question)
  end

  def vote?
    user.present? && !user.author?(record)
  end

  def like?
    vote?
  end

  def dislike?
    vote?
  end
end

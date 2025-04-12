class QuestionPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def update?
    user.author?(record)
  end

  def destroy?
    user.author?(record)
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

  def index?
    true
  end

  def show?
    true
  end
end

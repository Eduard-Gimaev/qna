class QuestionPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def update?
    record.user == user
  end

  def vote?
    user.present? && record.user != user
  end

  def destroy?
    record.user == user
  end

  def index?
    true
  end

  def show?
    true
  end

end
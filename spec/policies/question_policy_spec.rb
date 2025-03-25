require 'rails_helper'

RSpec.describe QuestionPolicy do
  subject { described_class }

  let (:user) { create :user }
  let (:author) { create :user }
  let (:question) { create :question, user: author }

  permissions :create? do
    it 'grants access if user is present' do
      expect(subject).to permit(user)
    end
    it 'denies access if user is not present' do
      expect(subject).not_to permit(nil)
    end
  end

  permissions :update? do
    it 'grants access if user is author' do
      expect(subject).to permit(author, question)
    end
    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, question)
    end
  end

  permissions :destroy? do 
    it 'grants access if user is author' do 
      expect(subject).to permit(author, question)
    end
    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, question)
    end
  end

  permissions :vote? do 
    it 'grants access if user is present and user is not author' do
      expect(subject).to permit(user, question)
    end
    it 'denies access if user is not present' do
      expect(subject).not_to permit(nil, question)
    end
    it 'denies access if user is author' do
      expect(subject).not_to permit(author, question)
    end
  end

  permissions :index?, :show? do
    it 'grants access to all users' do
      expect(subject).to permit(user)
    end
  end

end
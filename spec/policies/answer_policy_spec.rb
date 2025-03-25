require 'rails_helper'

RSpec.describe AnswerPolicy do
  subject { described_class }

  let(:user) { create :user }
  let(:author) { create :user }
  let(:question) { create :question, user: author }
  let(:answer) { create :answer, question: question, user: author } 

  permissions :create? do
    it 'grants access if user is present' do
      expect(subject).to permit(user)
    end
    it 'denies access if user is not present' do
      expect(subject).not_to permit(nil)
    end
  end

  permissions :update?, :destroy? do
    it 'grants access if user is author' do
      expect(subject).to permit(author, answer)
    end
    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, answer)
    end
  end

  permissions :mark_as_best? do 
    it 'grants access if user is author of question' do
      expect(subject).to permit(author, answer)
    end
    it 'denies access if user is not author of question' do
      expect(subject).not_to permit(user, answer)
    end
  end

  permissions :vote? do 
    it 'grants access if user is present and user is not author' do
      expect(subject).to permit(user, answer)
    end
    it 'denies access if user is not present' do
      expect(subject).not_to permit(nil, answer)
      
    end
    it 'denies access if user is author' do
      expect(subject).not_to permit(author, answer)
    end
  end
end
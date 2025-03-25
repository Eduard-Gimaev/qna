require 'rails_helper'

RSpec.describe AnswerPolicy do
  subject(:policy) { described_class }

  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:answer) { create(:answer, question: question, user: author) }

  shared_examples 'grants access if user is present' do
    it 'grants access if user is present' do
      expect(policy).to permit(user)
    end
  end

  shared_examples 'denies access if user is not present' do
    it 'denies access if user is not present' do
      expect(policy).not_to permit(nil)
    end
  end

  shared_examples 'grants access if user is author' do
    it 'grants access if user is author' do
      expect(policy).to permit(author, answer)
    end
  end

  shared_examples 'denies access if user is not author' do
    it 'denies access if user is not author' do
      expect(policy).not_to permit(user, answer)
    end
  end

  permissions :create? do
    include_examples 'grants access if user is present'
    include_examples 'denies access if user is not present'
  end

  permissions :update?, :destroy? do
    include_examples 'grants access if user is author'
    include_examples 'denies access if user is not author'
  end

  permissions :mark_as_best? do
    it 'grants access if user is author of question' do
      expect(policy).to permit(author, answer)
    end

    it 'denies access if user is not author of question' do
      expect(policy).not_to permit(user, answer)
    end
  end

  permissions :vote? do
    it 'grants access if user is present and user is not author' do
      expect(policy).to permit(user, answer)
    end

    it 'denies access if user is not present' do
      expect(policy).not_to permit(nil, answer)
    end

    it 'denies access if user is author' do
      expect(policy).not_to permit(author, answer)
    end
  end
end

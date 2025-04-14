require 'rails_helper'

RSpec.describe QuestionPolicy do
  subject(:policy) { described_class }

  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

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
      expect(policy).to permit(author, question)
    end
  end

  shared_examples 'denies access if user is not author' do
    it 'denies access if user is not author' do
      expect(policy).not_to permit(user, question)
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

  permissions :vote? do
    it 'grants access if user is present and user is not author' do
      expect(policy).to permit(user, question)
    end

    it 'denies access if user is not present' do
      expect(policy).not_to permit(nil, question)
    end

    it 'denies access if user is author' do
      expect(policy).not_to permit(author, question)
    end
  end

  permissions :index?, :show? do
    it 'grants access to all users' do
      expect(policy).to permit(user)
    end
  end
end

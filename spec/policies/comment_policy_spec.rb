require 'rails_helper'

RSpec.describe CommentPolicy do
  subject(:policy) { described_class }

  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }
  let(:comment) { create(:comment, commentable: question, user: author) }

  shared_examples 'grants access if user is present' do
    it 'grants access if user is present' do
      expect(policy).to permit(user, comment)
    end
  end

  shared_examples 'denies access if user is not present' do
    it 'denies access if user is not present' do
      expect(policy).not_to permit(nil, comment)
    end
  end

  shared_examples 'grants access if user is author' do
    it 'grants access if user is author' do
      expect(policy).to permit(author, comment)
    end
  end

  shared_examples 'denies access if user is not author' do
    it 'denies access if user is not author' do
      expect(policy).not_to permit(user, comment)
    end
  end

  permissions :create? do
    include_examples 'grants access if user is present'
    include_examples 'denies access if user is not present'
  end

  permissions :destroy? do
    include_examples 'grants access if user is author'
    include_examples 'denies access if user is not author'
  end
end

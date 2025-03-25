require 'rails_helper'

RSpec.describe CommentPolicy do
  subject { described_class }

  let(:user) { create :user }
  let(:author) { create :user }
  let(:question) { create :question, user: author }
  let(:comment) { create :comment, commentable: question, user: author }

  permissions :create? do
    it 'grants access if user is present' do
      expect(subject).to permit(user)
    end
    it 'denies access if user is not present' do
      expect(subject).not_to permit(nil)
    end
  end

  permissions :destroy? do
    it 'grants access if user is author' do
      expect(subject).to permit(author, comment)
    end
    it 'denies access if user is not author' do
      expect(subject).not_to permit(user, comment)
    end
  end
end
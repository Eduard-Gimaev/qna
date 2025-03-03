require 'rails_helper'

RSpec.shared_examples 'voted' do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:resource) { create(described_class.controller_name.classify.downcase.to_sym) }

  describe 'PATCH #like' do
    before do
      login(user)
      post :like, params: { id: resource.id }, format: :json
    end

    context 'when user is not the author of the entity' do
      it 'creates a vote(like)' do
        expect(resource.votes.count).to eq 1
      end

      it 'cancels a created vote(like)' do
        post :like, params: { id: resource.id }, format: :json
        expect(resource.votes.count).to eq 0
      end
    end
  end

  describe 'PATCH #dislike' do
    before do
      login(user)
      post :dislike, params: { id: resource.id }, format: :json
    end

    context 'when user is not the author of the entity' do
      it 'creates a vote(dislike)' do
        expect(resource.votes.count).to eq 1
      end

      it 'cancels a created vote(dislike)' do
        post :dislike, params: { id: resource.id }, format: :json
        expect(resource.votes.count).to eq 0
      end
    end
  end
end

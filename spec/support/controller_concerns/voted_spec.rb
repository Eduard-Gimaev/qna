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

    it 'creats a vote(like)' do
      expect(resource.votes[0].votable).to eq resource
    end

    it 'cancels a created vote(like)' do
      post :like, params: { id: resource.id }, format: :json

      expect(resource.votes.count).to eq 0
    end
  end

  describe 'PATCH #dislike' do
    before do
      login(user)
      post :dislike, params: { id: resource.id }, format: :json
    end

    it 'creats a vote(dislike)' do
      expect(resource.votes[0].votable).to eq resource
    end

    it 'cancels a created vote(dislike)' do
      post :dislike, params: { id: resource.id }, format: :json
      expect(resource.votes.count).to eq 0
    end
  end

  describe '#prepare_vote' do
    context 'when user is the author of the entity' do
      it 'renders an error message' do
        login(user)
        post :like, params: { id: resource.id, format: :json }
        expect(response.body).to include("You can't vote for your own #{resource.class.name.underscore}")
      end
    end

    context 'when user is not the author of the entity' do
      it 'renders the entity rating' do
        login(another_user)
        allow(resource).to receive(:make_vote).with(another_user, 'like')
        post :like, params: { id: resource.id, format: :json }
        expect(response.body).to eq('1')
      end
    end
  end
end
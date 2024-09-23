require 'rails_helper'

shared_examples 'voted' do
  let!(:author) { create(:user) }
  let!(:user) { create(:user) }
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
end
require 'rails_helper'

shared_examples 'voted' do
  let!(:author) { create(:user) }
  let!(:resource) { create(described_class.name.underscore.split("_")[0][0..-2].to_sym, user: author) }
  

  describe 'PATCH #like' do
  before do
      login(user)
      post :like, params: { id: resource.id }, format: :json
    end
  end

  it 'creates new like' do
      expect(resource.votes[0].votable).to eq resource
    end

end
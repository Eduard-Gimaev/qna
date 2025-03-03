require 'rails_helper'

shared_examples_for 'votable' do
  it { is_expected.to have_many(:votes).dependent(:destroy) }

  let!(:author) { create(:user) }
  let!(:resource) { create(described_class.name.underscore.to_sym, user: author) }
  let!(:group_five) { create_list(:user, 5) }
  let!(:group_three) { create_list(:user, 3) }

  describe '.make_vote' do
    it 'creates a vote(like)' do
      resource.make_vote(group_five[0], :like)
      resource.reload

      expect(resource.votes.count).to eq 1
    end

    it 'creates a vote(dislike)' do
      resource.make_vote(group_five[0], :dislike)
      resource.reload

      expect(resource.votes.count).to eq 1
    end

    it 'revotes and canceles a previous vote' do
      resource.make_vote(group_five[0], 'like')
      resource.make_vote(group_five[0], 'dislike')
      resource.reload
      expect(resource.votes.count).to eq 1
      expect(resource.votes[0].vote_type).to eq 'dislike'
      resource.make_vote(group_five[0], 'like')
      resource.reload
      expect(resource.votes.count).to eq 1
      expect(resource.votes[0].vote_type).to eq 'like'
    end
  end

  describe '.rating' do
    it 'displays a rating' do
      group_five.each do |user|
        resource.make_vote(user, 'like')
      end
      group_three.each do |user|
        resource.make_vote(user, 'dislike')
      end

      expect(resource.rating).to eq 2
    end
  end
end

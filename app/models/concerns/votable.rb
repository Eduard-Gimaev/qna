module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def make_vote(user, value)
    existing_vote = self.votes.find_by(user: user, votable: self)

    if existing_vote.nil?
      self.votes.create(user: user, vote_value: value, votable: self)
    elsif existing_vote.vote_value == value
      existing_vote.destroy
    else
      existing_vote.destroy
      self.votes.create(user: user, vote_value: value, votable: self)
    end
  end

  def rating
    likes = self.votes.where(vote_value: 'like').count
    dislikes = self.votes.where(vote_value: 'dislike').count
    rating = likes - dislikes
  end
end
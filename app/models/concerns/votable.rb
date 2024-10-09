module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def make_vote(user, value)
    existing_vote = votes.find_by(user:, votable: self)

    if existing_vote.nil?
      votes.create(user:, vote_value: value, votable: self)
    elsif existing_vote.vote_value == value
      existing_vote.destroy
    else
      existing_vote.destroy
      votes.create(user:, vote_value: value, votable: self)
    end
  end

  def rating
    likes = votes.where(vote_value: 'like').count
    dislikes = votes.where(vote_value: 'dislike').count
    likes - dislikes
  end
end

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def make_vote(user, vote_type)
    vote_type = Vote.vote_types[vote_type] if vote_type.is_a?(String)
    existing_vote = votes.find_by(user:, votable: self)

    if existing_vote.nil?
      votes.create(user: user, vote_type: vote_type, votable: self)
    elsif existing_vote.vote_type == Vote.vote_types.key(vote_type)
      existing_vote.destroy
    else
      existing_vote.update(vote_type: vote_type)
    end
  end

  def rating
    votes.sum(:vote_type)
  end
end

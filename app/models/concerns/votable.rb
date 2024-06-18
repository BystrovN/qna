module Votable
  extend ActiveSupport::Concern

  VoteResult = Struct.new(:success, :rating, :errors)

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_by(user, value)
    vote = votes.find_by(user: user)

    if vote&.value == value
      cancel_vote_by(user)
      return VoteResult.new(true, rating, nil)
    elsif vote
      vote.value = value
    else
      vote = votes.new(user: user, value: value)
    end

    vote.save ? VoteResult.new(true, rating, nil) : VoteResult.new(false, nil, vote.errors.full_messages)
  end

  def rating
    votes.sum(:value)
  end

  def voted_by?(user)
    votes.exists?(user: user)
  end

  def cancel_vote_by(user)
    votes.where(user: user).destroy_all
  end
end

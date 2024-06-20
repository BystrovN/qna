module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_by(user, value)
    vote = votes.find_or_initialize_by(user: user)
    if vote.persisted? && vote.value == value
      cancel_vote_by(user)
    else
      vote.value = value
      vote.save
    end
  end

  def rating
    votes.sum(:value)
  end

  def cancel_vote_by(user)
    vote = votes.find_by(user: user)
    vote&.update(value: 0)
  end
end

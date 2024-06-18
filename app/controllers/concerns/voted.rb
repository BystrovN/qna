module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: %i[vote_up vote_down cancel_vote]
  end

  def vote_up
    vote(1)
  end

  def vote_down
    vote(-1)
  end

  private

  def find_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end

  def vote(value)
    render_vote_result(@votable.vote_by(current_user, value))
  end

  def render_vote_result(vote_result)
    if vote_result.success
      render json: { success: true, rating: vote_result.rating }
    else
      render json: { success: false, errors: vote_result.errors }, status: :unprocessable_entity
    end
  end
end

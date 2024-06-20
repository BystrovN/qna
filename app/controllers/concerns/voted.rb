module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: %i[vote_up vote_down]
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
    if @votable.vote_by(current_user, value)
      render json: { success: true, rating: @votable.rating }
    else
      render json: { success: false, errors: @votable.errors.full_messages }, status: :unprocessable_entity
    end
  end
end

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  default_scope { order(best: :desc) }
  scope :best, -> { where(best: true) }

  def set_best!
    transaction do
      unless best?
        question.answers.best.update_all(best: false) if question.answers.best.any?
        update!(best: true)
      end
    end
  end

  private

  def best?
    best
  end
end

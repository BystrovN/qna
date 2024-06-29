class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  default_scope { order(best: :desc) }
  scope :best, -> { where(best: true) }

  def set_best!
    transaction do
      unless best?
        question.answers.best.update_all(best: false) if question.answers.best.any?
        update!(best: true)
        question.reward&.update!(user: user)
      end
    end
  end

  private

  def best?
    best
  end
end

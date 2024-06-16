class Reward < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question

  has_one_attached :image

  validates :title, presence: true
  validate :image_is_an_image

  private

  def image_is_an_image
    return unless image.attached? && !image.content_type.in?(%w[image/jpeg image/png])

    errors.add(:image, 'must be a JPEG or PNG')
  end
end

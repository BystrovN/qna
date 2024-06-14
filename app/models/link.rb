class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validate :url_format_valid?

  def gist?
    url.include?('gist.github.com')
  end

  private

  def url_format_valid?
    uri = URI.parse(url)
    unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
      errors.add(:url, 'is not a valid URL')
    end
  rescue URI::InvalidURIError
    errors.add(:url, 'is not a valid URL')
  end
end

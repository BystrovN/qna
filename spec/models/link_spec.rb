require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should belong_to(:linkable) }

  describe 'validations' do
    let(:question) { create(:question) }
    let(:valid_link) { build(:link, url: 'https://example.com', linkable: question) }
    let(:invalid_link) { build(:link, url: 'invalid_url', linkable: question) }

    it 'is valid with a valid URL' do
      expect(valid_link).to be_valid
    end

    it 'is invalid with an invalid URL' do
      expect(invalid_link).not_to be_valid
      expect(invalid_link.errors[:url]).to include('is not a valid URL')
    end
  end
end

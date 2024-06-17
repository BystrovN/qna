require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should belong_to(:user).optional }
  it { should belong_to(:question) }

  it 'has one attached file' do
    expect(Reward.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  describe 'validations' do
    let(:reward) { build(:reward) }

    context 'with valid image content type' do
      it 'is valid with a JPEG image' do
        reward.image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.jpeg')), filename: 'test.jpeg', content_type: 'image/jpeg')
        expect(reward).to be_valid
      end

      it 'is valid with a PNG image' do
        reward.image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.png')), filename: 'test.png', content_type: 'image/png')
        expect(reward).to be_valid
      end
    end

    context 'with invalid image content type' do
      it 'is not valid with a non-JPEG/PNG image' do
        reward.image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.gif')), filename: 'test.gif', content_type: 'image/gif')
        expect(reward).not_to be_valid
        expect(reward.errors[:image]).to include('must be a JPEG or PNG')
      end
    end
  end
end

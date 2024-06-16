require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:nullify) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }
    let(:other_answer) { create(:answer, user: other_user, question: question) }

    it 'returns true if user is the author of the resource' do
      expect(user.author_of?(answer)).to eq true
    end

    it 'returns false if user is not the author of the resource' do
      expect(user.author_of?(other_answer)).to eq false
    end
  end
end

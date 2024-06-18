require 'rails_helper'

RSpec.shared_examples 'votable' do
  let(:user) { create(:user) }
  let(:votable_instance) { described_class.new(id: 1) }

  describe '#vote_by' do
    context 'when voting for the first time' do
      it 'creates a new vote' do
        expect do
          votable_instance.vote_by(user, 1)
        end.to change(Vote, :count).by(1)
      end

      it 'returns a success result' do
        result = votable_instance.vote_by(user, 1)
        expect(result.success).to eq(true)
        expect(result.errors).to be_nil
      end
    end

    context 'when changing an existing vote' do
      before do
        votable_instance.vote_by(user, 1)
      end

      it 'updates the existing vote' do
        expect do
          votable_instance.vote_by(user, -1)
        end.not_to change(Vote, :count)
      end

      it 'returns a success result' do
        result = votable_instance.vote_by(user, -1)
        expect(result.success).to eq(true)
        expect(result.errors).to be_nil
      end
    end

    context 'when canceling a vote' do
      before do
        votable_instance.vote_by(user, 1)
      end

      it 'cancels the existing vote' do
        expect do
          votable_instance.vote_by(user, 1)
        end.to change(Vote, :count).by(-1)
      end

      it 'returns a success result' do
        result = votable_instance.vote_by(user, 1)
        expect(result.success).to eq(true)
        expect(result.errors).to be_nil
      end
    end
  end

  describe '#rating' do
    it 'returns the correct rating based on votes' do
      votable_instance.vote_by(user, 1)
      votable_instance.vote_by(create(:user), -1)
      expect(votable_instance.rating).to eq(0)
    end
  end

  describe '#voted_by?' do
    context 'when user has voted' do
      before do
        votable_instance.vote_by(user, 1)
      end

      it 'returns true' do
        expect(votable_instance.voted_by?(user)).to eq(true)
      end
    end

    context 'when user has not voted' do
      it 'returns false' do
        expect(votable_instance.voted_by?(user)).to eq(false)
      end
    end
  end
end

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
end

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'
end

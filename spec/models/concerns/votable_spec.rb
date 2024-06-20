require 'rails_helper'

RSpec.shared_examples 'votable' do
  let(:user) { create(:user) }
  let(:votable_instance) { described_class.new(id: 1) }

  describe '#vote_by' do
    context 'when voting for the first time' do
      it 'creates a new vote' do
        expect { votable_instance.vote_by(user, 1) }.to change(Vote, :count).by(1)
      end

      it 'returns true' do
        result = votable_instance.vote_by(user, 1)
        expect(result).to be true
      end
    end

    context 'when changing an existing vote' do
      before { votable_instance.vote_by(user, 1) }

      it 'updates the existing vote' do
        expect { votable_instance.vote_by(user, -1) }.not_to change(Vote, :count)
        expect(votable_instance.votes.find_by(user: user).value).to eq(-1)
      end

      it 'returns true' do
        result = votable_instance.vote_by(user, -1)
        expect(result).to be true
      end
    end

    context 'when canceling a vote' do
      before { votable_instance.vote_by(user, 1) }

      it 'does not delete the vote but sets value to 0' do
        expect { votable_instance.vote_by(user, 1) }.not_to change(Vote, :count)
        expect(votable_instance.votes.find_by(user: user).value).to eq(0)
      end

      it 'returns true' do
        result = votable_instance.vote_by(user, 1)
        expect(result).to be true
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
end

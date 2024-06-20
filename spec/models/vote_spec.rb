require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:existing_vote) { create(:vote, user: user, votable: question) }

  it { should belong_to(:user) }
  it { should belong_to(:votable) }

  it 'validates uniqueness of user scoped to votable' do
    new_vote = Vote.new(user: user, votable: question, value: 1)
    expect(new_vote).not_to be_valid
    expect(new_vote.errors[:user_id]).to include('has already been taken')
  end

  it { should validate_inclusion_of(:value).in_array([1, 0, -1]) }
end

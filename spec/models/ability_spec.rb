require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other_user) }
    let(:answer) { create(:answer, user: user) }
    let(:other_anser) { create(:answer, user: other_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }

    [Question, Answer].each { |object| it { should be_able_to :add_comment, object } }

    it 'can update own question' do
      should be_able_to :update, question
    end

    it 'cannot update others questions' do
      should_not be_able_to :update, other_question
    end

    it 'can update own answer' do
      should be_able_to :update, answer
    end

    it 'cannot update others answers' do
      should_not be_able_to :update, other_anser
    end

    it 'can vote up or down on questions and answers' do
      should be_able_to :vote_up, other_question
      should be_able_to :vote_down, other_question

      should be_able_to :vote_up, other_anser
      should be_able_to :vote_down, other_anser
    end

    it 'cannot vote up or down on own questions and answers' do
      should_not be_able_to :vote_up, question
      should_not be_able_to :vote_down, question

      should_not be_able_to :vote_up, answer
      should_not be_able_to :vote_down, answer
    end

    it 'can mark the best answer for own question' do
      answer = create(:answer, question: question, user: other_user)
      should be_able_to :best, answer
    end

    it 'cannot mark the best answer for others questions' do
      answer = create(:answer, question: other_question, user: other_user)
      should_not be_able_to :best, answer
    end

    it 'can destroy own links' do
      link = create(:link, linkable: question)
      should be_able_to :destroy, link
    end

    it 'cannot destroy others links' do
      link = create(:link, linkable: other_question)
      should_not be_able_to :destroy, link
    end

    it 'can destroy own attachments' do
      attachment = ActiveStorage::Attachment.create(record: question)
      should be_able_to :destroy, attachment
    end

    it 'cannot destroy others attachments' do
      attachment = ActiveStorage::Attachment.create(record: other_question)
      should_not be_able_to :destroy, attachment
    end
  end
end

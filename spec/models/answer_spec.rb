require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question).required }
  it { should belong_to(:user).required }

  it { should have_many(:links).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of :body }

  describe '#set_best!' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }

    context 'when there are no best answers for the question' do
      it 'sets the answer as the best' do
        answer.set_best!
        expect(answer.reload.best).to eq true
      end
    end

    context 'when there is already a best answer for the question' do
      let!(:best_answer) { create(:answer, question: question, user: user, best: true) }

      it 'changes the best answer to the new one' do
        answer.set_best!
        best_answer.reload
        expect(best_answer.best).to eq false
        expect(answer.reload.best).to eq true
      end
    end

    context 'when the answer is already the best' do
      let!(:best_answer) { create(:answer, question: question, user: user, best: true) }

      it 'keeps the answer as the best' do
        best_answer.set_best!
        expect(best_answer.reload.best).to eq true
      end
    end
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end

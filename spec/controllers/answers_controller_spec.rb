require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    context 'when user is authenticated' do
      before { sign_in(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect do
            post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
          end.to change(Answer, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect do
            post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question },
                          format: :js
          end.to_not change(Answer, :count)
        end

        it 'renders create template' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
          expect(response).to render_template :create
        end
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign in page' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'when user is the author' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question path' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'when user is not the author' do
      let(:other_user) { create(:user) }
      let!(:other_answer) { create(:answer, question: question, user: other_user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: other_answer, question_id: question } }.not_to change(Answer, :count)
      end

      it 'redirects to question path' do
        delete :destroy, params: { id: other_answer, question_id: question }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end
end

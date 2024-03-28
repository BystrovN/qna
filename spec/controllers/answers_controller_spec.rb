require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #new' do
    context 'when user is authenticated' do
      before { sign_in(user) }

      before { get :new, params: { question_id: question } }

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context 'when user is not authenticated' do
      it 'redirects to sign in page' do
        get :new, params: { question_id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'when user is authenticated' do
      before { sign_in(user) }

      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect do
            post :create, params: { question_id: question, answer: attributes_for(:answer) }
          end.to change(Answer, :count).by(1)
        end

        it 'redirects to show question view' do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect do
            post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
          end.to_not change(Answer, :count)
        end

        it 're-renders new view' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
          expect(response).to render_template :new
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
end

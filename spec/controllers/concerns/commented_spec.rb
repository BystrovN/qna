require 'rails_helper'

RSpec.shared_examples 'commented' do
  let(:user) { create(:user) }
  let(:commentable) { create(described_class.to_s.gsub('Controller', '').singularize.underscore.to_sym) }

  describe 'POST #add_comment' do
    context 'when user is authenticated' do
      before { login(user) }

      context 'with valid parameters' do
        it 'creates a new comment' do
          expect do
            post :add_comment, params: { id: commentable.id, comment: { body: 'Test comment' }, format: :js }
          end.to change(Comment, :count).by(1)
        end

        it "renders 'add_comment' template" do
          post :add_comment, params: { id: commentable.id, comment: { body: 'Test comment' }, format: :js }
          expect(response).to render_template(:add_comment)
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new comment' do
          expect do
            post :add_comment, params: { id: commentable.id, comment: { body: '' }, format: :js }
          end.not_to change(Comment, :count)
        end

        it "renders 'add_comment' template with errors" do
          post :add_comment, params: { id: commentable.id, comment: { body: '' }, format: :js }
          expect(response).to render_template(:add_comment)
          expect(assigns(:comment).errors).not_to be_empty
        end
      end
    end

    context 'when user is not authenticated' do
      context 'with valid parameters' do
        it 'does not create a new comment' do
          expect do
            post :add_comment, params: { id: commentable.id, comment: { body: 'Test comment' }, format: :js }
          end.not_to change(Comment, :count)
        end

        it 'redirects to sign in' do
          post :add_comment, params: { id: commentable.id, comment: { body: 'Test comment' } }
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end
  end
end

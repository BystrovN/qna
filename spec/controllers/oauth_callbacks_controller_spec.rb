require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  shared_examples 'OAuth provider' do |provider|
    let(:oauth_data) { { 'provider' => provider, 'uid' => 123 } }

    it "finds user from #{provider} oauth data" do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get provider
    end

    context "when user exists for #{provider}" do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get provider
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context "when user does not exist for #{provider}" do
      before do
        allow(User).to receive(:find_for_oauth)
        get provider
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to be_nil
      end
    end
  end

  describe 'Github' do
    it_behaves_like 'OAuth provider', 'github'
  end

  describe 'Vkontakte' do
    it_behaves_like 'OAuth provider', 'vkontakte'
  end
end

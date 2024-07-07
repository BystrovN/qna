require 'rails_helper'

feature 'User can sign in with OAuth providers', '
  In order to sign in
  As an unauthenticated user
  I want to be able to sign in with OAuth providers
' do
  background { visit new_user_session_path }

  providers = {
    github: 'GitHub',
    vkontakte: 'Vkontakte'
  }

  providers.each do |provider, display_name|
    describe "sign in with #{display_name}" do
      scenario 'successfully signs in' do
        mock_auth_hash(provider)
        click_on "Sign in with #{display_name}"
        expect(page).to have_content "Successfully authenticated from #{provider.capitalize} account"
        expect(page).to have_link 'Sign out'
      end

      scenario 'handles authentication error' do
        OmniAuth.config.mock_auth[provider] = :invalid_credentials
        click_on "Sign in with #{display_name}"

        expect(page).to have_content 'Authentication failed'
      end
    end
  end
end

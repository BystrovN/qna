require 'rails_helper'

RSpec.feature 'User can sign up', "
  In order to become a member of the community
  As a unauthenticated user
  I'd like to be able to sign up
" do
  scenario 'Guest user signs up with valid credentials' do
    visit new_user_registration_path
    user = build(:user)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Guest user fails to sign up with invalid credentials' do
    visit new_user_registration_path
    user = build(:user, :invalid)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end
end

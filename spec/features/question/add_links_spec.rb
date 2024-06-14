require 'rails_helper'

RSpec.feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:valid_gist_url) { 'https://github.com' }
  given(:invalid_gist_url) { 'xxxx' }

  before do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
  end

  scenario 'User adds valid link when asks question', js: true do
    click_on 'Add Link'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: valid_gist_url
    click_on 'Ask'

    expect(page).to have_link('My gist', href: valid_gist_url)
  end

  scenario 'User adds invalid link when asks question', js: true do
    click_on 'Add Link'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: invalid_gist_url
    click_on 'Ask'

    expect(page).to have_content('Links url is not a valid URL')
  end

  scenario 'Link input form is initially hidden', js: true do
    expect(page).not_to have_selector('.nested-fields')

    click_on 'Add Link'
    expect(page).to have_selector('.nested-fields')
  end
end

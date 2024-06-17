require 'rails_helper'

RSpec.feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:valid_url) { 'https://github.com' }
  given(:invalid_url) { 'xxxx' }

  background do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'This is my answer'
  end

  scenario 'User adds valid link when submits answer', js: true do
    click_on 'Add Link'
    fill_in 'Link name', with: 'My link'
    fill_in 'Url', with: valid_url
    click_on 'Answer'

    expect(page).to have_link('My link', href: valid_url)
  end

  scenario 'User adds invalid link when submits answer', js: true do
    click_on 'Add Link'
    fill_in 'Link name', with: 'My link'
    fill_in 'Url', with: invalid_url
    click_on 'Answer'

    expect(page).to have_content('Links url is not a valid URL')
  end

  scenario 'Link input form is initially hidden', js: true do
    expect(page).not_to have_selector('.nested-fields')

    click_on 'Add Link'
    expect(page).to have_selector('.nested-fields')
  end
end

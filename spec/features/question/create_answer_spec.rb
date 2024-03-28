require 'rails_helper'

RSpec.feature 'User can answer question on question page', "
  In order to provide an answer to a question
  As a user
  I'd like to be able to write an answer on the question page
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user writes an answer to the question' do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'This is my answer'
    click_on 'Answer'

    expect(page).to have_content 'Your answer successfully created'
    expect(page).to have_content 'This is my answer'
  end

  scenario 'Unauthenticated user tries to write an answer' do
    visit question_path(question)

    expect(page).not_to have_selector 'textarea#answer_body'
    expect(page).not_to have_button 'Answer'
  end
end

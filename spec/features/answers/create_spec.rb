require 'rails_helper'

RSpec.feature 'User can answer question on question page', "
  In order to provide an answer to a question
  As a user
  I'd like to be able to write an answer on the question page
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user writes an answer to the question', js: true do
    sign_in(user)
    visit question_path(question)

    answer = build(:answer)
    fill_in 'Body', with: answer.body
    click_on 'Answer'

    expect(page).to have_content answer.body
  end

  scenario 'Unauthenticated user tries to write an answer' do
    visit question_path(question)

    expect(page).not_to have_selector 'textarea#answer_body'
    expect(page).not_to have_button 'Answer'
  end

  scenario 'Authenticated user writes an invalid answer to the question', js: true do
    sign_in(user)
    visit question_path(question)

    answer = build(:answer, :invalid)
    fill_in 'Body', with: answer.body
    click_on 'Answer'

    expect(page).to have_content "Body can't be blank"
  end
end

require 'rails_helper'

RSpec.feature 'User can mark an answer as the best', "
  In order to mark the most helpful answer
  As a user
  I'd like to be able to mark an answer as the best
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user, who is the author of the question, marks an answer as the best', js: true do
    sign_in(user)
    visit question_path(question)

    within "#answer_#{answer.id}" do
      click_on 'Set as best'
    end

    expect(page).to have_content 'Best answer'
  end

  scenario 'Authenticated user, who is not the author of the question, tries to mark an answer as the best' do
    another_user = create(:user)
    sign_in(another_user)
    visit question_path(question)

    expect(page).not_to have_link 'Set as best'
  end

  scenario 'Unauthenticated user tries to mark an answer as the best' do
    visit question_path(question)

    expect(page).not_to have_link 'Set as best'
  end
end

require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in user
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      sign_in user
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's question" do
      other_user = create(:user)
      other_question = create(:question, user: other_user)
      create(:answer, question: other_question, user: other_user)

      sign_in user
      visit question_path(other_question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end

require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      fill_in 'Title', with: 'Edited title'
      fill_in 'question_body', with: 'Edited body'

      click_on 'Ask'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body

      expect(page).to have_content 'Edited title'
      expect(page).to have_content 'Edited body'
    end

    scenario 'edits his question with errors', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      fill_in 'Title', with: ''
      fill_in 'question_body', with: 'Edited body'

      click_on 'Ask'

      expect(page).to have_content question.title
      expect(page).to have_content question.body

      expect(page).to have_selector 'textarea'
      expect(page).to have_content "Title can't be blank"
    end

    scenario "tries to edit other user's question" do
      other_user = create(:user)
      other_question = create(:question, user: other_user)

      sign_in user
      visit question_path(other_question)

      expect(page).to_not have_link 'Edit'
    end

    scenario 'edits his question with attached files', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      fill_in 'Title', with: 'Edited title'
      fill_in 'question_body', with: 'Edited body'
      attach_file 'question_files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body

      expect(page).to have_content 'Edited title'
      expect(page).to have_content 'Edited body'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end
end

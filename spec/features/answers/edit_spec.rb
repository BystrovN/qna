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
        click_on 'Answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
      end
    end

    scenario 'edits his answer with errors', js: true do
      sign_in user
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        fill_in 'Body', with: ''
        click_on 'Answer'

        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's answer" do
      other_user = create(:user)
      other_question = create(:question, user: other_user)
      create(:answer, question: other_question, user: other_user)

      sign_in user
      visit question_path(other_question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario 'edits his answer with attached files', js: true do
      sign_in user
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        fill_in 'Body', with: 'edited answer'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'delete his answer attached files', js: true do
      file_name = 'rails_helper.rb'
      sign_in user
      answer.files.attach(
        io: File.open("#{Rails.root}/spec/#{file_name}"),
        filename: file_name
      )
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        expect(page).to have_link file_name
        click_on 'X'
        expect(page).to_not have_link file_name
      end
    end
  end
end

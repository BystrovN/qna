require 'rails_helper'

RSpec.feature 'Add comment to question', js: true do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  scenario "comment appears on another user's page" do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end

    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      expect(page).to have_text(question.title)

      fill_in "comment_body_question_#{question.id}", with: 'Test comment for question'
      click_on 'Add comment'

      expect(page).to have_content 'Test comment for question'
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'Test comment for question'
    end
  end
end

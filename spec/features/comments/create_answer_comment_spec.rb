require 'rails_helper'

RSpec.feature 'Add comment to answer', js: true do
  let(:user) { create(:user) }
  let(:answer) { create(:answer) }

  scenario "comment appears on another user's page" do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(answer.question)
    end

    Capybara.using_session('guest') do
      visit question_path(answer.question)
    end

    Capybara.using_session('user') do
      within "#answer_#{answer.id}" do
        fill_in "comment_body_answer_#{answer.id}", with: 'Test comment for answer'
        click_on 'Add comment'
      end

      expect(page).to have_content 'Test comment for answer'
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'Test comment for answer'
    end
  end
end

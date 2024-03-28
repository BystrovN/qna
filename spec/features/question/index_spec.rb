require 'rails_helper'

RSpec.feature 'User can view list of questions', "
  In order to find questions
  As a user
  I'd like to be able to view list of questions
" do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  scenario 'User views list of questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_link question.title, href: question_path(question)
      expect(page).to have_content question.body
    end
  end
end

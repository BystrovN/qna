require 'rails_helper'

RSpec.feature 'User can view question and its answers', "
  In order to see question details and answers
  As a user
  I'd like to be able to view question and its answers
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  scenario 'User views question and its answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end

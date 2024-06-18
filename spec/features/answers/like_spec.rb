require 'rails_helper'

RSpec.feature 'Answer likes and dislikes', js: true do
  let!(:user) { create(:user) }
  let!(:answer) { create(:answer) }

  before do
    sign_in(user)
    visit question_path(answer.question)
  end

  scenario 'User likes an answer' do
    within('.answer-rating') do
      click_button '👍'
    end

    expect(page).to have_content('Rating:1')
  end

  scenario 'User dislikes an answer' do
    within('.answer-rating') do
      click_button '👎'
    end

    expect(page).to have_content('Rating:-1')
  end

  scenario 'User cancels their vote' do
    within('.answer-rating') do
      click_button '👍'
    end
    expect(page).to have_content('Rating:1')
    within('.answer-rating') do
      click_button '👍'
    end
    expect(page).to have_content('Rating:0')

    expect(page).to have_button('👍')
    expect(page).to have_button('👎')
  end

  scenario 'User dislikes after likes' do
    within('.answer-rating') do
      click_button '👍'
    end
    expect(page).to have_content('Rating:1')
    within('.answer-rating') do
      click_button '👎'
    end
    expect(page).to have_content('Rating:-1')
  end
end

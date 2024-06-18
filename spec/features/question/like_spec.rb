require 'rails_helper'

RSpec.feature 'Question likes and dislikes', js: true do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User likes a question' do
    click_button '👍'

    expect(page).to have_content('Rating:1')
  end

  scenario 'User dislikes a question' do
    click_button '👎'

    expect(page).to have_content('Rating:-1')
  end

  scenario 'User cancels their vote' do
    click_button '👍'
    expect(page).to have_content('Rating:1')
    click_button '👍'
    expect(page).to have_content('Rating:0')

    expect(page).to have_button('👍')
    expect(page).to have_button('👎')
  end

  scenario 'User likes after dislikes' do
    click_button '👎'
    expect(page).to have_content('Rating:-1')
    click_button '👍'
    expect(page).to have_content('Rating:1')
  end
end

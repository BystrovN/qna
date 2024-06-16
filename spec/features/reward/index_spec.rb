require 'rails_helper'

RSpec.feature 'User can view rewards list', "
  In order to see my achievements
  As a user
  I want to be able to view all rewards
" do
  feature 'Authenticated user can see list of his rewards' do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }
    given!(:user_rewards) { create_list(:reward, 3, user: user, question: question) }

    background do
      sign_in(user)
    end

    scenario 'User sees rewards list' do
      visit rewards_path

      user_rewards.each do |reward|
        expect(page).to have_content reward.title
        expect(page).to have_content reward.question.title
      end
    end
  end
end

require 'rails_helper'

feature 'User can add reward to question', '
  In order to add reward
  As an authenticated user
  I would like to be able to add reward
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user:) }

  describe 'Authenticated user', :js do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask a new question'
      fill_in 'question[title]', with: 'Title of the question'
      fill_in 'question[body]', with: 'Text of the question'
    end
    scenario 'adds a reward while asking a new question' do
      within '.add-reward' do
        fill_in 'Reward', with: 'The best answer'
        attach_file 'Image', "#{Rails.root}/app/assets/images/reward.png"
      end
      click_on 'Ask'
      
      expect(page).to have_content 'The best answer'
      expect(page).to have_css("img[src*='reward.png']")
    end
  end
end
  
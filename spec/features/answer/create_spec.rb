require 'rails_helper'

feature 'User can create answer', %q{
  In order to give an answer to a question on the question page
  As an authenticated User
  I'd like to be able to give answer while in the question page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
      save_and_open_page
    end

    scenario 'gives an asnwer to a question' do
      fill_in 'answer[body]', with: 'answer body'

      click_on 'Reply'
    
      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'answer body'
    end

    scenario 'gives an asnwer with errors'
  end

end
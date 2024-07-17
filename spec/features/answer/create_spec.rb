require 'rails_helper'

feature 'User can create answer', %q{
  In order to give an answer to a question on the question page
  As an authenticated User
  I'd like to be able to give answer while in the question page
} do

  describe 'Authenticated user' do

    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'gives an asnwer to a question' do
      fill_in 'answer[title]', with: 'title'
      fill_in 'answer[body]', with: 'body'

      click_on 'Reply'

      expect(page).to have_content 'title'
      expect(page).to have_content 'body'
    end

    scenario 'gives an asnwer with errors' do 
      click_on 'Reply'
      expect(page).to have_content "Title can't be blank"

    end
  end

  describe 'Unauthenticated user' do 
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }

    scenario 'tries to create an answer' do 
      visit question_path(question)
      click_on 'Reply'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end

end
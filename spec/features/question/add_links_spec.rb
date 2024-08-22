require 'rails_helper'

feature 'User can add links to question', '
  In order to add links
  As an authenticated user
  I would like to be able to add links
' do
  given(:user) { create(:user) }
  given(:gist_url) {'https://gist.github.com/Eduard-Gimaev/514a5411559d7e42a2d1c74ad56f18bf'}

  
  describe 'Authenticated user' do

    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask a new question'
    end

    scenario 'adds links when ask question' do
      fill_in 'question[title]', with: 'Title of the question'
      fill_in 'question[body]', with: 'Text of the question'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
require 'rails_helper'

feature 'User can add links to answer', '
  In order to add links
  As an authenticated user
  I would like to be able to add links
' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user:) }
  given(:gist_url) {'https://gist.github.com/Eduard-Gimaev/514a5411559d7e42a2d1c74ad56f18bf'}

  
  describe 'Authenticated user' do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'adds links when give an answer', :js do
      fill_in 'answer[body]', with: 'My answer'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Reply'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
      end
    end
  end
end
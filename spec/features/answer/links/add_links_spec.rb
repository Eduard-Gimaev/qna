require 'rails_helper'

feature 'User can add links to answer', '
  In order to add links
  As an authenticated user
  I would like to be able to add links
' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user:) }
  given(:google_url) { 'https://google.com' }
  given(:yandex_url) { 'https://ya.ru' }
  given(:gist_url) { 'https://gist.github.com/Eduard-Gimaev/514a5411559d7e42a2d1c74ad56f18bf' }

  describe 'Authenticated user', :js do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'answer[body]', with: 'My answer'
    end

    scenario 'adds links when give an answer' do
      fill_in 'Link name', with: 'google'
      fill_in 'Url', with: google_url

      click_on 'add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'yandex'
        fill_in 'Url', with: yandex_url
      end
      click_on 'Reply'

      within '.answers' do
        expect(page).to have_link 'google', href: google_url
        expect(page).to have_link 'yandex', href: yandex_url
      end
    end

    scenario 'adds link with invalid url while giving an answer' do
      fill_in 'Link name', with: 'google'
      fill_in 'Url', with: 'invalid url'

      click_on 'Reply'

      within '.answer-errors' do
        expect(page).to have_content 'Links url is invalid'
        expect(page).to have_no_link 'google', href: 'invalid url'
      end
    end

    scenario 'adds a link of the gist' do
      fill_in 'Link name', with: 'Gist'
      fill_in 'Url', with: gist_url
      click_on 'Reply'
      expect(page).to have_content 'Hello world!'
    end
  end
end

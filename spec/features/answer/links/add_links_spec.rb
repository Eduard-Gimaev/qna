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

  describe 'Authenticated user', :js do
    scenario 'adds links when give an answer' do
      sign_in(user)
      visit question_path(question)

        fill_in 'answer[body]', with: 'My answer'
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
  end
end

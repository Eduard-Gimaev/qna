require 'rails_helper'

feature 'User can edit links in the answer', '
  In order to edit links
  As an authenticated user
  I would like to be able to edit links
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user:) }
  given!(:answer) { create(:answer, question:, user:) }
  given(:google_url) { 'https://google.com' }
  given(:yandex_url) { 'https://ya.ru' }

  describe 'Authenticated user', :js do
    scenario 'edits links' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit'
      within '.answers' do
        click_on 'add link'
        within all('.nested-fields').last do
          fill_in 'Link name', with: 'yandex'
          fill_in 'Url', with: yandex_url
        end

        click_on 'add link'
        within all('.nested-fields').last do
          fill_in 'Link name', with: 'google'
          fill_in 'Url', with: google_url
        end
        click_on 'Save'

        expect(page).to have_link 'yandex', href: yandex_url
        expect(page).to have_link 'google', href: google_url
      end
    end
  end
end

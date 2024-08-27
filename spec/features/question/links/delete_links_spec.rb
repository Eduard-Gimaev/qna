require 'rails_helper'

feature 'User can edit links in the question', '
  In order to edit links
  As an authenticated user
  I would like to be able to edit links
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user:) }
  given!(:link) { create(:link, linkable: question) }
  
  describe 'Authenticated user', :js do
    scenario 'deletes links' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit a question'
      expect(page).to have_link 'Link_name', href: 'Link_URL'

      click_on 'x'
      click_on 'Save'
      expect(page).to have_no_link 'Link_name'
    end
  end
end
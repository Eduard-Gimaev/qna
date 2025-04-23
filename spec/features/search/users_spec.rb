require 'sphinx_helper'

feature 'User can search for users', "
  In order to find needed user
  As a User
  I'd like to be able to search for the user
" do
  given!(:user) { create(:user, email: 'test_user@example.com') }

  before do
    sign_in(user)
    visit questions_path
  end

  scenario 'User searches for a user', :sphinx do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: 'test_user@example.com'
      select 'Users', from: 'scope'
      click_on 'Search'

      expect(page).to have_content 'test_user@example.com'
    end
  end

  scenario 'User searches for a non-existent user', :sphinx do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: 'nonexistent_user@example.com'
      select 'Users', from: 'scope'
      click_on 'Search'

      expect(page).to have_content 'No results found'
    end
  end
end

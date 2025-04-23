require 'sphinx_helper'

feature 'User can search for comments', "
  In order to find needed comment
  As a User
  I'd like to be able to search for the comment
" do
  given!(:user) { create(:user) }
  given!(:comment) { create(:comment, body: 'Test comment', user: user) }

  before do
    sign_in(user)
    visit questions_path
  end

  scenario 'User searches for a comment', :sphinx do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: 'Test comment'
      select 'Comments', from: 'scope'
      click_on 'Search'

      expect(page).to have_content 'Test comment'
    end
  end

  scenario 'User searches for a non-existent comment', :sphinx do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: 'Non-existent comment'
      select 'Comments', from: 'scope'
      click_on 'Search'

      expect(page).to have_content 'No results found'
    end
  end
end

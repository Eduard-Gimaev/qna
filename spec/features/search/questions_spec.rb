require 'sphinx_helper'

feature 'User can search for questions', "
  In order to find needed question
  As a User
  I'd like to be able to search for the question
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, title: 'Test question', body: 'Test body', user: user) }

  before do
    sign_in(user)
    visit questions_path
  end

  scenario 'User searches for a question by title', :sphinx do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: 'Test question'
      select 'Questions', from: 'scope'
      click_on 'Search'

      expect(page).to have_content 'Test question'
      expect(page).to have_content 'Test body'
    end
  end

  scenario 'User searches for a non-existent question', :sphinx do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: 'Non-existent question'
      select 'Questions', from: 'scope'
      click_on 'Search'

      expect(page).to have_content 'No results found'
    end
  end
end

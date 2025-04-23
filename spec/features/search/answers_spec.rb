require 'sphinx_helper'

feature 'User can search for answers', "
  In order to find needed answer
  As a User
  I'd like to be able to search for the answer
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, body: 'Test answer', question: question, user: user) }

  before do
    sign_in(user)
    visit questions_path
  end

  scenario 'User searches for an answer', :sphinx do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: 'Test answer'
      select 'Answers', from: 'scope'
      click_on 'Search'

      expect(page).to have_content 'Test answer'
    end
  end

  scenario 'User searches for a non-existent answer', :sphinx do
    ThinkingSphinx::Test.run do
      fill_in 'query', with: 'Non-existent answer'
      select 'Answers', from: 'scope'
      click_on 'Search'

      expect(page).to have_content 'No results found'
    end
  end
end

# spec/features/comment/create_comment_spec.rb
require 'rails_helper'

feature 'User can create comment', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'adds a comment to the question', :js do
      within '.new-comment-question' do
        fill_in 'comment[body]', with: 'Сomment for a question'
        click_on 'Submit'
      end
      within "#comments-list-question-#{question.id}" do
        expect(page).to have_content 'Сomment for a question'
      end
    end

    scenario 'adds a comment to the answer', :js do
      within '.new-comment-answer' do
        fill_in 'comment[body]', with: 'Сomment for an answer'
        click_on 'Submit'
      end
      within "#comments-list-answer-#{answer.id}" do
        expect(page).to have_content 'Сomment for an answer'
      end
    end
  end
end

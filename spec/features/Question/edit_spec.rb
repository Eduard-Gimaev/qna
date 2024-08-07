# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user:) }

  describe 'Authenticated user' do
    context 'when an author' do
      background do
        sign_in(user)
        visit question_path(question)
        click_on 'Edit a question'
      end

      scenario 'edits his question', :js do
        fill_in 'question[title]', with: 'Edited title'
        fill_in 'question[body]', with: 'Edited body'

        click_on 'Save'

        within '.question' do
          expect(page).to have_no_content question.title
          expect(page).to have_no_content question.body
          expect(page).to have_content 'Edited title'
          expect(page).to have_content 'Edited body'
          expect(page).to have_no_css 'textarea'
        end
      end

      scenario 'edits his question with errors', :js do
        fill_in 'question[title]', with: ' '
        fill_in 'question[body]', with: ' '

        click_on 'Save'

        within '.question' do
          expect(page).to have_content question.title
          expect(page).to have_content question.body
        end

        within '.question-errors' do
          expect(page).to have_content "Title can't be blank"
          expect(page).to have_content "Body can't be blank"
        end
      end
    end

    context 'when non author' do
      scenario "tries to edit other user's question", :js do
        sign_in(other_user)
        visit question_path(question)

        expect(page).to have_no_link 'Edit question'
      end
    end
  end

  scenario 'Unathenticated user can not edit an question' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to have_content question.body
    expect(page).to have_no_link 'Edit a question'
  end
end

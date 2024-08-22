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

  describe 'Authenticated user', :js do
    context 'when an author' do
      background do
        sign_in(user)
        question.files.attach(io: Rails.root.join('spec', 'rails_helper.rb').open, filename: 'rails_helper.rb', content_type: 'text/plain')
        question.save
        visit question_path(question)
        click_on 'Edit a question'
      end

      scenario 'edits his question without errors' do
        within '.question' do
          fill_in 'question[title]', with: 'edited title'
          fill_in 'question[body]', with: 'edited body'
          # attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

          click_on 'Save'

          expect(page).to have_no_content question.title
          expect(page).to have_no_content question.body
          expect(page).to have_content 'edited title'
          expect(page).to have_content 'edited body'
          expect(page).to have_no_css 'textarea'
          # expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'tries to delete attachments' do
        within '.question' do
          expect(page).to have_link 'rails_helper.rb'
        end
        click_on 'x'

        expect(page).to have_no_link 'spec_helper.rb'
      end

      scenario 'edits his question with errors' do
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
      scenario "tries to edit other user's question" do
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
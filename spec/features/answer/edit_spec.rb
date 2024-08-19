# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit an answer', '
  In order to correct mistake
  As an author of the answer
  I would like to be able to edit my answer
' do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user:) }
  given!(:answer) { create(:answer, question:, user:) }

  describe 'Authenticated user', :js do
    describe 'When an author' do
      background do
        sign_in(user)
        question.files.attach(io: File.open(Rails.root.join('spec', 'rails_helper.rb')), filename: 'rails_helper.rb', content_type: 'text/plain')
        answer.files.attach(io: File.open(Rails.root.join('spec', 'spec_helper.rb')), filename: 'spec_helper.rb', content_type: 'text/plain')
        question.save
        answer.save

        visit question_path(question)
        click_on 'Edit an answer'
      end

      scenario 'edits his answer' do
        within '.answers' do
          fill_in 'answer[body]', with: 'edited answer'
          attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
          click_on 'Save'

          expect(page).to have_no_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to have_no_css 'textarea'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'tries to delete attachments' do 
        within '.answers' do 
          expect(page).to have_link 'spec_helper.rb'

          click_on 'x'
          click_on 'Save'
          
          expect(page).to have_no_link 'spec_helper.rb'
        end
      end

      scenario 'edits his answer with errors' do
        within '.answers' do
          fill_in 'answer[body]', with: ''
          click_on 'Save'

          expect(page).to have_content answer.body
          expect(page).to have_content answer.body
        end
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'tries to edit foreign answer' do
      sign_in(other_user)
      visit question_path(question)
      expect(page).to have_content answer.body
      expect(page).to have_no_link 'Edit an answer'
    end
  end

  scenario 'Unathenticated user can not edit an answer' do
    sign_in(other_user)
    visit question_path(question)
    expect(page).to have_content answer.body
    expect(page).to have_no_link 'Edit an answer'
  end
end

require 'rails_helper'

feature 'User can edit an answer', %q{
  In order to correct mistake
  As an author of the answer
  I would like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create :question, user: user }
  given!(:answer) { create :answer, question: question, user: user }

  describe 'Authenticated user', :js do 
    describe 'Author' do 
      background do
        sign_in(user)
        visit question_path(question)
        click_on 'Edit an answer'
      end

      scenario 'edits his answer' do 
        within '.answers' do
          fill_in 'answer[body]', with: 'edited answer'
          click_on 'Save'

          expect(page).to have_no_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to have_no_css 'textarea'
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
      expect(page).to_not have_link 'Edit an answer'
    end
  end

  scenario 'Unathenticated user can not edit an answer' do 
    sign_in(other_user)
    visit question_path(question)
    expect(page).to have_content answer.body
    expect(page).to_not have_link 'Edit an answer'
  end
end
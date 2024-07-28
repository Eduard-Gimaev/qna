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

  describe 'Authenticated user' do 

    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit'
    end

    scenario 'edits his answer' do 
      within '.answers' do
        fill_in 'answer[body]', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
    scenario 'edits his answer with errors'
    scenario 'tries to edit foreign answer'
  end

  scenario 'Unathenticated user can not edit an answer' do 
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

end
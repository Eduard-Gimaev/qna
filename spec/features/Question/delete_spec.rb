require 'rails_helper'

feature 'User can delete his own question', %q{
  In order to delete question
  As an authenticated user
  I would like to be able to delete his own question
} do 

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create :question, user: user }
  

  scenario 'User tries to delete his own question' do 
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content question.body
    click_on 'Delete a question'
    
    expect(page).to have_content 'Question successfully deleted.'
    expect(page).to_not have_content question.title
  end
  scenario 'User tries to delete a question that does not belong' do 
    sign_in(other_user)
    visit question_path(question)
    expect(page).to have_content question.body
    expect(page).to_not have_content 'Delete a question'
  end
end
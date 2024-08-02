require 'rails_helper'

feature 'User can delete his own answer', %q{
  In order to delete an answer
  as authenticated user
  I would like to be able to delete an answer
} do 
  
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create :question, user: user }
  given!(:answer) { create :answer, question: question, user: user }
  

  scenario 'User tries to delete own answer', :js do 
    sign_in(user)
    visit question_path(question)
    
    within '.answers' do
        expect(page).to have_content answer.body
    end

    click_on 'Delete an answer'

    expect(page).to_not have_content answer.body
  end

  scenario 'Other user tries to delete an answer that does not belong', :js do 
    sign_in(other_user)
    visit question_path(question)
    expect(page).to have_content answer.body
    expect(page).to_not have_link 'Delete an answer'
  end

end
require 'rails_helper'

feature 'User can view a list of questions', %q{
  In order to get answer from a comunity
  As any user
  I'd like to be able to view a list of questions
} do 
  given(:user) { create(:user) }
  given!(:question1) { create(:question, user: user) }
  given!(:question2) { create(:question, user: user) }

  scenario 'Authenticated user can view a list of questions' do 
    sign_in(user)
    visit questions_path 

    expect(page).to have_content question1.title
    expect(page).to have_content question1.body
    expect(page).to have_content question2.title
    expect(page).to have_content question2.body
  end
  scenario 'Unauthenticated user can view a list of questions' do 
    visit questions_path 

    expect(page).to have_content question1.title
    expect(page).to have_content question1.body
    expect(page).to have_content question2.title
    expect(page).to have_content question2.body
  end
end
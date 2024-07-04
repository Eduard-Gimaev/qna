require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a comunity
  As an authenticated user
  I'd like to be able to ask the question
} do
  given(:user) { User.create!(email: 'user@test.com', password: '12345678' ) }

  scenario 'Authenticated user asks a question' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Title of the question'
    fill_in 'Body', with: 'Text of the question'
    click_on 'Ask'
# save_and_open_page
    expect(page).to have_content 'Your question was successfully created.'
    expect(page).to have_content 'Title of the question'
    expect(page).to have_content 'Text of the question'
  end

  scenario 'Authenticated user asks a question with errors'
  scenario 'Unauthenticated user tries to ask a question' 
end

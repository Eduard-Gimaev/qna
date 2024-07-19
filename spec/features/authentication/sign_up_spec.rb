require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As an unauthenticated User
  I'd like to be able to sign up
} do
  background {visit new_user_registration_path}

  scenario 'User tries to sign up with valid data' do 
    fill_in 'Email', with: 'user@email.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User tries to sign up with invalid data' do 
    click_on 'Sign up'

    expect(page).to have_content 'prohibited this user from being saved:'

  end
end
require 'spec_helper'
require 'capybara/rspec'

feature 'User can sign in', %q{
  In order to ask question
  As an unauthenticated user
  I would like to be able to sign in
} do
  scenario 'Registered user tries to sign in' do
    User.create!(email: 'user@test.com', password: '12345678')
    
    visit '/login'
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'

    expect(page).to have_content 'Signed in succesfully.'
  end

  scenario 'Unregistred user tries to sign in'
end

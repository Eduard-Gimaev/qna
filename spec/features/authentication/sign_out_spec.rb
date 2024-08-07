# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign out', '
  In order to terminate the current session
  as an authenticated user
  I would like to be able to sign out
' do
  given(:user) { create(:user) }

  scenario 'Authenticated user tries to sign out' do
    sign_in(user)

    click_on 'Log Out'

    expect(page).to have_content 'Signed out successfully.'
  end
end

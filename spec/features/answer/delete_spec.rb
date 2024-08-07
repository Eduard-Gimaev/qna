# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete his own answer', '
  In order to delete an answer
  as authenticated user
  I would like to be able to delete an answer
' do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user:) }
  given!(:answer) { create(:answer, question:, user:) }

  scenario 'User tries to delete own answer', :js do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      expect(page).to have_content answer.body
    end

    click_on 'Delete an answer'

    expect(page).to have_no_content answer.body
  end

  scenario 'Other user tries to delete an answer that does not belong', :js do
    sign_in(other_user)
    visit question_path(question)
    expect(page).to have_content answer.body
    expect(page).to have_no_link 'Delete an answer'
  end
end

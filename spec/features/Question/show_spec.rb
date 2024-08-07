# frozen_string_literal: true

require 'rails_helper'

feature 'User can view question and answers to it', "
  In order to get answer from a community
  As any user
  I'd like to be able to view question and answers to it
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user:) }
  given!(:answer) { create(:answer, body: 'a1', question:, user:) }

  scenario 'Authenticate user review question and answers to it' do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end

  scenario 'Unauthenticate user review question and answers to it' do
    visit question_path(question)

    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end
end

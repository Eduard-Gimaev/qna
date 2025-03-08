# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question', "
  In order to get answer from a comunity
  As an authenticated user
  I'd like to be able to ask the question
" do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
      click_on 'Ask a new question'
    end

    scenario 'asks a question' do
      save_and_open_page
      fill_in 'question[title]', with: 'Title of the question'
      fill_in 'question[body]', with: 'Text of the question'
      click_on 'Ask'

      expect(page).to have_content 'Title of the question'
      expect(page).to have_content 'Text of the question'
    end

    scenario 'asks a question with attached file' do
      fill_in 'question[title]', with: 'Title of the question'
      fill_in 'question[body]', with: 'Text of the question'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask a new question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end

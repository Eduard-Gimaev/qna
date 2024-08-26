# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', "
  In order to give an answer to a question on the question page
  As an authenticated User
  I'd like to be able to give answer while in the question page
" do
  describe 'Authenticated user', :js do
    given!(:user) { create(:user) }
    given!(:question) { create(:question, user:) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'gives an asnwer to a question' do
      fill_in 'answer[body]', with: 'My answer'

      click_on 'Reply'

      expect(page).to have_current_path question_path(question), ignore_query: true
      within '.answers' do
        expect(page).to have_content 'My answer'
      end
    end

    scenario 'gives an answer with attached file' do
      fill_in 'answer[body]', with: 'My answer'
      attach_file 'answer_files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Reply'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'gives an asnwer with errors' do
      click_on 'Reply'

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Unauthenticated user' do
    given(:user) { create(:user) }
    given(:question) { create(:question, user:) }

    scenario 'tries to create an answer' do
      visit question_path(question)
      click_on 'Reply'
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end

require 'rails_helper'

feature 'User can choose the best answer', %q{
  In order to help other people with the best answer
  As an author of question
  I'd like to be able to choose the best answer for question
} do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create :answer, question: question, user: user }

  describe 'Authenticated user', :js do
    scenario 'tries to set the best answer for his question' do
      sign_in(user)
      visit question_path(question)

      within "#answer-#{answer.id}" do
        expect(page).not_to have_content 'the best answer!'
        click_on 'The best answer'
        expect(page).to have_content 'the best answer!'
      end
    end

    scenario "tries to set the best answer for foreigner's question" do
      sign_in(user2)
      visit question_path(question)

      expect(page).to_not have_link 'The best answer'
    end
  end
end
require 'rails_helper'

feature 'User can vote for an answer', %q{
  In order to give personal attitude
  As a non author of entity
  I want to be able to vote for an answer
} do
  given!(:author) { create :user }
  given!(:non_author) { create :user }
  given!(:question) { create :question, user: author }
  given!(:answer) { create :answer, question: question, user: author }

  describe 'Authenticated user', :js do
    context 'when non author of the answer' do
      background do
        sign_in(non_author)
        visit question_path(question)
      end

      scenario 'tries to like' do
        within '.answers' do
          expect(page).to have_content "0"
          click_on 'Like'
          expect(page).to have_content "1"
        end
      end

      scenario 'tries to like again', :js do
         within '.answers' do
          click_on 'Like'
          expect(page).to have_content "1"
          click_on 'Like'
          expect(page).to have_content "1" # Assuming user can't like twice
        end
      end

      scenario 'tries to dislike', :js do
         within '.answers' do
          expect(page).to have_content "0"
          click_on 'Dislike'
          expect(page).to have_content "-1"
        end
      end

      scenario 'tries to dislike again', :js do
         within '.answers' do
          click_on 'Dislike'
          expect(page).to have_content "-1"
          click_on 'Dislike'
          expect(page).to have_content "-1" # Assuming user can't dislike twice
        end
      end
    end

    context 'when author of the answer' do
      background do
        sign_in(author)
        visit question_path(question)
      end

      scenario 'tries to like his own answer', :js do
         within '.answers' do
          expect(page).to have_content "0"
          click_on 'Like'
          expect(page).to have_content "0" # Assuming author can't vote for his own answer
        end
      end

      scenario 'tries to dislike his own answer', :js do
        within '.answers' do
          expect(page).to have_content "0"
          click_on 'Dislike'
          expect(page).to have_content "0" # Assuming author can't vote for his own answer
        end
      end
    end
  end
end
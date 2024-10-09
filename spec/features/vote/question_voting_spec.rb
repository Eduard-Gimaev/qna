require 'rails_helper'

feature 'User can vote for a question', '
  In order to give personal attitude
  As a non author of entity
  I want to be able to vote for a question
' do
  given!(:author) { create(:user) }
  given!(:non_author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'Authenticated user', :js do
    context 'when non author of the question' do
      background do
        sign_in(non_author)
        visit question_path(question)
      end

      scenario 'tries to like' do
        within '.question' do
          expect(page).to have_content '0'
          click_on 'Like'
          expect(page).to have_content '1'
        end
      end

      scenario 'tries to like again' do
        within '.question' do
          click_on 'Like'
          expect(page).to have_content '1'
          click_on 'Like'
          expect(page).to have_content '1'
        end
      end

      scenario 'tries to dislike' do
        within '.question' do
          expect(page).to have_content '0'
          click_on 'Dislike'
          expect(page).to have_content '-1'
        end
      end

      scenario 'tries to dislike again' do
        within '.question' do
          click_on 'Dislike'
          expect(page).to have_content '-1'
          click_on 'Dislike'
          expect(page).to have_content '-1' # Assuming user can't dislike twice
        end
      end
    end

    context 'when author of the question' do
      background do
        sign_in(author)
        visit question_path(question)
      end

      scenario 'tries to like his own question' do
        within '.question' do
          expect(page).to have_content '0'
          click_on 'Like'
          expect(page).to have_content '0'
          expect(page).to have_content "You can't vote for your own question"
        end
      end

      scenario 'tries to dislike his own question' do
        within '.question' do
          expect(page).to have_content '0'
          click_on 'Dislike'
          expect(page).to have_content '0'
          expect(page).to have_content "You can't vote for your own question"
        end
      end
    end
  end
end

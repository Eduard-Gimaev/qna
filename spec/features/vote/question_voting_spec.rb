require 'rails_helper'

feature 'User can vote for a question ', %q{
  In order to give personal attitude
  As an author of entity
  I want to be able to vote for a question
} do
  given!(:author) { create :user }
  given!(:non_author) { create :user }
  given!(:question) { create :question, user: author }

  describe 'Authenticated user' do
    context 'when non author of the question' do
      background do
        sign_in(non_author)
        visit question_path(question)
      end

      scenario 'tries to Like' do
        within '.question' do
          expect(page).to have_content "0"
          click_on 'Like'

          expect(page).to have_content "1"
        end
      end
      scenario 'tries to like again'
      scenario 'tries to dislike'
      scenario 'tries to dislike again'
    end
    context 'when author of the question' do 
      scenario 'tries to like his own question'
      scenario 'tries to dislike his own question'
    end
  end
end

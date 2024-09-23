require 'rails_helper'

feature 'User can vote for an answer ', %q{
  In order to give personal attitude
  As a non author of entity
  I want to be able to vote for an answer
} do
  given!(:author) { create :user }
  given!(:non_author) { create :user }
  given!(:question) { create :question, user: author }
  given!(:answer) { create(:answer, question:, user: author ) }

  describe 'Authenticated user' do
    context 'when non author of the answer' do
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
    context 'when author of the answer' do 
      scenario 'tries to like his own answer'
      scenario 'tries to dislike his own answer'
    end
  end
end

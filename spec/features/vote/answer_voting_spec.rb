require 'rails_helper'

feature 'User can vote for an answer', '
  In order to give personal attitude
  As a non author of entity
  I want to be able to vote for an answer
' do
  given!(:author) { create(:user) }
  given!(:non_author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question:, user: author) }

  describe 'Authenticated user', :js do
    context 'when non author of the answer' do
      background do
        sign_in(non_author)
        visit question_path(question)
      end

      scenario 'tries to like' do
        within '.answers' do
          expect(page).to have_content '0'
          click_on 'Like'
          expect(page).to have_content '1'
        end
      end

      scenario 'tries to dislike' do
        within '.answers' do
          expect(page).to have_content '0'
          click_on 'Dislike'
          expect(page).to have_content '-1'
        end
      end

      scenario 'destroys existing vote if the same vote type is given' do
        answer.make_vote(non_author, 'like')
        expect(answer.votes.count).to eq 1

        answer.make_vote(non_author, 'like')
        expect(answer.votes.count).to eq 0
      end
    end

    context 'when author of the answer' do
      background do
        sign_in(author)
        visit question_path(question)
      end

      scenario 'tries to like his own answer' do
        within '.answers' do
          expect(page).to have_content '0'
          click_on 'Like'
          expect(page).to have_content '0' # Assuming author can't vote for his own answer
        end
      end

      scenario 'tries to dislike his own answer' do
        within '.answers' do
          expect(page).to have_content '0'
          click_on 'Dislike'
          expect(page).to have_content '0' # Assuming author can't vote for his own answer
        end
      end
    end
  end
end

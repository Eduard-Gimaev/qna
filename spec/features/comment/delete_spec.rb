require "rails_helper"

feature "User can delete his own comment", '
  In order to delete comment
  As an authenticated user
  I would like to be able to delete his own comment
' do    

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:question_comment) { create(:comment, commentable: question, user: user, body: 'Comment for the question') }
  given!(:answer_comment) { create(:comment, commentable: answer, user: user, body: 'Comment for the answer') }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario "User tries to delete his own comment for the question", :js do
    # within "#comments-list-question-#{question.id}" do
    #   expect(page).to have_content 'Comment for the question'
    #   click_on 'Delete'
    #   expect(page).to_not have_content 'Comment for the question'
    # end
  end

  scenario "User tries to delete his own comment for the answer", :js do
    # within "#comments-list-answer-#{answer.id}" do
    #   expect(page).to have_content 'Comment for the answer'
    #   click_on 'Delete'
    #   expect(page).to_not have_content 'Comment for the answer'
    # end
  end
end


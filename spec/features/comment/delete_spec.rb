require "rails_helper"

feature "User can delete his own comment", '
  In order to delete comment
  As an authenticated user
  I would like to be able to delete his own comment
' do    

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }
  given(:question_comment) { create(:comment, commentable: question, user: user) }
  given(:answer_comment) { create(:comment, commentable: answer, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario "User tries to delete his own comment for the question", :js do
    question_comment
    # expect(page).to have_content question_comment.body
     within "#comment-#{question_comment.id}" do
      click_on "Delete"
    end
  end

  scenario "User tries to delete his own comment for the answer", :js do
    answer_comment
    # expect(page).to have_content answer_comment.body
    within "#comment-#{answer_comment.id}" do
      click_on "Delete"
    end
    expect(page).to have_no_content answer_comment.body
  end
end


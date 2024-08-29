require 'rails_helper'

feature 'User can view all his rewards', '
  In order to view rewards
  As an authenticated user
  I would like to be able to view rewards
' do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user:) }
  given!(:reward) do
    create(:reward,
           image: fixture_file_upload("#{Rails.root}/app/assets/images/reward.png"),
           question_id: question.id)
  end
  given!(:answer) { create(:answer, question:, user:) }

  scenario 'Authenticated user earns a reward', :js do
    sign_in(user)
    visit question_path(question)

    within "#answer-#{answer.id}" do
      expect(page).to have_no_content 'BEST'
      click_on 'The best answer'
      expect(page).to have_content 'BEST'
    end

    visit questions_path
    click_on 'My rewards'

    expect(page).to have_content question.title
    expect(page).to have_content reward.title
    expect(page).to have_css("img[src*='reward.png']")
  end
end

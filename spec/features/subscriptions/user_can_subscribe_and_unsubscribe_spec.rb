require 'rails_helper'

feature 'User can subscribe and unsubscribe from a question', :js do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario 'User subscribes' do
    expect(page).to have_button 'Subscribe'

    click_button 'Subscribe'

    expect(page).to have_content 'You have subscribed to'
    expect(page).to have_button 'Unsubscribe'
  end

  scenario 'User unsubscribes after subscribing' do
    user.subscriptions.create!(question: question)

    visit question_path(question)

    expect(page).to have_button 'Unsubscribe'

    click_button 'Unsubscribe'

    expect(page).to have_content 'You have unsubscribed from'
    expect(page).to have_button 'Subscribe'
  end
end

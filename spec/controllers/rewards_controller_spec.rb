require 'rails_helper'

RSpec.describe RewardsController do
  let!(:user) { create(:user) }
  let!(:question1) { create(:question, user:) }
  let!(:question2) { create(:question, user:) }
  let!(:reward1) do
    create(:reward,
           image: fixture_file_upload("#{Rails.root}/app/assets/images/reward.png"),
           user_id: user.id,
           question_id: question1.id)
  end
  let!(:reward2) do
    create(:reward,
           image: fixture_file_upload("#{Rails.root}/app/assets/images/reward.png"),
           user_id: user.id,
           question_id: question2.id)
  end

  describe 'GET #index' do
    before do
      login(user)
      get :index, params: { user_id: user.id }
    end

    it 'populates an array of all rewards' do
      expect(assigns(:rewards)).to contain_exactly(reward1, reward2)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'when user is logged in' do
      before { sign_in user }

      it 'creates a subscription and redirects to question' do
        expect {
          post :create, params: { question_id: question.id }
        }.to change { user.subscriptions.count }.by(1)

        expect(flash[:notice]).to eq("You have subscribed to #{question.title}")
        expect(response).to redirect_to(question)
      end

      it 'sends a subscription email' do
        expect {
          post :create, params: { question_id: question.id }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)

        subscription_email = ActionMailer::Base.deliveries.last
        expect(subscription_email.to).to include(user.email)
        expect(subscription_email.subject).to eq("You have subscribed to #{question.title}")
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        post :create, params: { question_id: question.id }
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is logged in' do
      before { sign_in user }
      let!(:subscription) { user.subscriptions.create!(question: question) }

      it 'destroys the subscription and redirects to question' do
        expect {
          delete :destroy, params: { id: subscription.id }
        }.to change { user.subscriptions.count }.by(-1)

        expect(flash[:notice]).to eq("You have unsubscribed from #{question.title}")
        expect(response).to redirect_to(question)
      end

      it 'sends an unsubscribe email' do
        expect {
          delete :destroy, params: { question_id: question.id, id: subscription.id }
        }.to change { ActionMailer::Base.deliveries.count }.by(1)

        unsubscribe_email = ActionMailer::Base.deliveries.last
        expect(unsubscribe_email.to).to include(user.email)
        expect(unsubscribe_email.subject).to eq("You have unsubscribed from #{question.title}")
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        delete :destroy, params: { question_id: question.id, id: 1 }
        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end
end

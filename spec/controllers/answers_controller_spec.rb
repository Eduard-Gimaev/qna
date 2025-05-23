require 'rails_helper'

RSpec.describe AnswersController do
  it_behaves_like 'voted' do
    let(:entity) { answer }
    let(:entity_class) { Answer }
  end

  let(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, user:) }
  let!(:answer) { create(:answer, question:, user:) }
  let!(:answer2) { create(:answer, question:, user: user2) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        login(user)
        expect do
          post :create,
               params: { question_id: question.id,
                         answer: attributes_for(:answer, question_id: question.id, user_id: user.id) }, format: :js
        end.to change(Answer, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save an answer in DB' do
        expect do
          post :create,
               params: { question_id: question.id,
                         answer: attributes_for(:answer, :invalid, question_id: question.id) }, format: :js
        end.not_to change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'updates an answer attributes' do
        patch :update, params: { id: answer.id, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not update an answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.not_to change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #mark_as_best' do
    context 'when user tries to set the best answer to the foreign question' do
      before do
        login(user)
        patch :mark_as_best, params: { id: answer }, format: :js
      end

      it 'marks the best answer' do
        expect { answer.reload }.to change(answer, :best).from(false).to(true)
      end

      it 'renders mark_best template' do
        expect(response).to render_template :mark_as_best
      end
    end

    context 'when user tries to set the best answer to his own question' do
      before do
        login(user2)
        patch :mark_as_best, params: { id: answer2 }, format: :js
      end

      it 'does not set the best answer' do
        expect { answer2.reload }.not_to change(answer2, :best)
      end

      it 'does not render mark_best template' do
        expect(response).not_to render_template :mark_as_best
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'when an author of the answer tries to delete an answer' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'when non author of the answer tries to delete an answer' do
      it 'does not destroy the answer, if user_id is wrong' do
        login(user2)
        expect { delete :destroy, params: { id: answer }, format: :js }.not_to change(Answer, :count)
      end
    end

    it 'render destroy' do
      delete :destroy, params: { id: answer }, format: :js
      expect(response).to render_template :destroy
    end
  end
end

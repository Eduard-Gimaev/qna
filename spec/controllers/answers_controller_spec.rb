require 'rails_helper'

RSpec.describe AnswersController, type: :controller do 
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

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
                         answer: attributes_for(:answer, 
                                                :invalid, 
                                                question_id: question.id)}, format: :js
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

  describe 'DELETE #destroy' do
    before { login(user) }
    
    context 'by an author of the answer' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'by non-autho of the answer' do
      it 'does not destroy the answer, if user_id is wrong' do 
        login(user2)
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(0)
      end
    end

      it 'render destroy' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end

  end
   


end
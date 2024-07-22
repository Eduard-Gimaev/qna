require 'rails_helper'

RSpec.describe AnswersController, type: :controller do 
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do

    context 'with valid attributes' do

      it 'saves a new answer in the database' do
        login(user)
        expect do
          post :create,
               params: { question_id: question.id,
                         answer: attributes_for(:answer, question_id: question.id, author_id: user.id) }, format: :js
        end.to change(Answer, :count).by(1)
      end
    end

    context 'with invalid attributes' do

      it 'does not save a answer in DB' do
        expect do
          post :create, 
               params: { question_id: question.id, 
                         answer: attributes_for(:answer, 
                                                :invalid, 
                                                question_id: question.id)}
        end.not_to change(Answer, :count)
      end
    end
  end

end
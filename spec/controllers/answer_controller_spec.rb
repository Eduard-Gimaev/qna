require 'rails_helper'

RSpec.describe AnswersController, type: :controller do 

  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  # let(:answers) { create_list(:answer, 3, question: question) }
  
  # describe 'GET #index' do 
  #   let(:question) { create(:question) }
  #   let(:answers) { create_list(:answer, 3, question: question) }

  #   before {get :index, params: { id: question }}
    
  #   it 'Populates an array of all answers' do 
  #     expect(assigns(:answers)).to match_array(@answers)
  #   end

  #   it 'Renders index view' do 
  #     expect(response).to render_template :index
  #   end
  # end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect do
          post :create, 
               params: { question_id: question.id, 
               answer: attributes_for(:answer, 
                                      question_id: question.id)}
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
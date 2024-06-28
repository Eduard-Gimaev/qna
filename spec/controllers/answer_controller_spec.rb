require 'rails_helper'

RSpec.describe AnswersController, type: :controller do 
  
  describe 'GET #index' do 
    let(:question) { create(:question) }
    let(:answers) {create_list(:answer, 3, question: question)}

    before {get :index, params: { id: question }}
    
    it 'Populates an array of all answers' do 
      expect(assigns(:answers)).to match_array(@answers)
      
    end

    it 'Renders index view' do 
      expect(response).to render_template :index
    end
  end

end
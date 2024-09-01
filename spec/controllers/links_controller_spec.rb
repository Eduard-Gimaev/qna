# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, user:) }
  let!(:answer) { create(:answer, question:, user:) }
  let!(:question_link) { create(:link, linkable: question) }
  let!(:answer_link) { create(:link, linkable: answer) }

  describe 'DELETE #destroy' do
    context 'when question:' do
      context 'when an author of the question tries to delete a link' do
        it 'deletes a link' do
          login(user)
          delete :destroy, params: { id: question_link }, format: :js
          question.reload
          expect(response).to render_template :destroy
        end
      end

      context 'when non author of the question tries to delete a link' do
        it 'deletes a link' do
          login(user2)
          delete :destroy, params: { id: question.links.first }, format: :js
          question.reload
          expect { delete :destroy, params: { id: question_link }, format: :js }.not_to change(Link, :count)
        end
      end
    end
  end

  context 'when answer:' do
    context 'when an author of the answer tries to delete a link' do
      it 'deletes a link' do
        login(user)
        delete :destroy, params: { id: answer.links.first }, format: :js
        answer.reload
        expect(response).to render_template :destroy
      end
    end

    context 'when non author of the answer tries to delete a link' do
      it 'deletes a link' do
        login(user2)
        delete :destroy, params: { id: answer.links.first }, format: :js
        answer.reload
        expect { delete :destroy, params: { id: question_link }, format: :js }.not_to change(Link, :count)
      end
    end
  end
end

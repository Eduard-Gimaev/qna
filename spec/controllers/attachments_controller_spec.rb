# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, user:) }
  let!(:answer) { create(:answer, question:, user:) }

  describe 'DELETE #destroy' do
    context 'when question:' do
      before do
        question.files.attach(io: Rails.root.join('spec', 'rails_helper.rb').open, filename: 'rails_helper.rb', content_type: 'text/plain')
        question.save
      end

      context 'when an author of the question tries to delete an attachment' do
        it 'deletes an attachment' do
          login(user)
          delete :destroy, params: { id: question.files.first }, format: :js
          question.reload
          expect(question.files.attached?).to be false
        end
      end

      context 'when non author of the question tries to delete an attachment' do
        it 'deletes an attachment' do
          login(user2)
          delete :destroy, params: { id: question.files.first }, format: :js
          question.reload
          expect(question.files.attached?).to be true
        end
      end
    end
  end

  context 'when answer:' do
    before do
      answer.files.attach(io: Rails.root.join('spec', 'rails_helper.rb').open, filename: 'rails_helper.rb', content_type: 'text/plain')
      answer.save
    end

    context 'when an author of the answer tries to delete an attachment' do
      it 'deletes an attachment' do
        login(user)
        delete :destroy, params: { id: answer.files.first }, format: :js
        answer.reload
        expect(answer.files.attached?).to be false
      end
    end

    context 'when non author of the answer tries to delete an attachment' do
      it 'deletes an attachment' do
        login(user2)
        delete :destroy, params: { id: answer.files.first }, format: :js
        answer.reload
        expect(answer.files.attached?).to be true
      end
    end
  end
end

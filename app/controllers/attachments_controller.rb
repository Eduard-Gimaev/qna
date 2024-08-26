# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @entity = find_entity(@attachment).find(@attachment.record_id)
    @attachment.purge if current_user.author?(@entity)
  end

  private

  def find_entity(entity)
    case entity.record_type
    when 'Question' then Question
    when 'Answer' then Answer
    else raise StandardError, entity.inspect
    end
  end
end

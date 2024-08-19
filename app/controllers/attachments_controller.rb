class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_attachment, only: %i[destroy]

  def destroy
    @entity = find_entity(@attachment).find(@attachment.record_id)
    @attachment.purge if current_user.author?(@entity)
  end

  private

  def find_attachment 
    @attachment = ActiveStorage::Attachment.find_by(blob_id: params[:id])
  end

  def find_entity(entity)
    case entity.record_type
      when "Question" then Question
      when "Answer" then Answer
    end
  end
end

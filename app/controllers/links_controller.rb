class LinksController < ApplicationController
  def destroy
    @link = Link.find(params[:id])
    @entity = @link.linkable_type.constantize.where(id: @link.linkable_id).first
    @link.destroy if current_user.author?(@entity)
  end
end

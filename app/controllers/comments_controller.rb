class CommentsController < ApplicationController
  include Commented

  def create
    create_comment
  end

  def destroy
    destroy_comment
  end
end

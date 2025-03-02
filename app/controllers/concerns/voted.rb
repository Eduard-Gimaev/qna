module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_entity, only: %i[like dislike]
  end

  def like
    render_vote(params[:action])
  end

  def dislike
    render_vote(params[:action])
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def find_entity
    @entity = model_klass.find(params[:id])
  end

  def render_vote(vote_type)
    respond_to do |format|
      if current_user.author?(@entity)
        format.json do
          render json: { error: "You can't vote for your own #{model_klass.to_s.downcase}" }
        end
      else
        @entity.make_vote(current_user, vote_type)
        format.json { render json: @entity.rating }
      end
    end
  end
end

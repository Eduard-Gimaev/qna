class Api::V1::BaseController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :doorkeeper_authorize!

  private

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def record_not_found(exception)
    render json: { errors: "#{exception.message}" }, status: :not_found
  end
end

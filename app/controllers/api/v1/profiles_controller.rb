class Api::V1::ProfilesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :doorkeeper_authorize!

  def me
    render json: current_resource_owner, status: :ok
  end

  private

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
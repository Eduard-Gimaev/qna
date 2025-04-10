class Api::V1::ProfilesController < Api::V1::BaseController

  def index
    @profiles = User.where.not(id: current_resource_owner.id)
  
    render json: @profiles, each_serializer: UserSerializer, status: :ok
  end

  def me
    render json: current_resource_owner, serializer: UserSerializer, status: :ok
  end
end
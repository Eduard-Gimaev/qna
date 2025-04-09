class Api::V1::ProfilesController < Api::V1::BaseController

  # def index
  #   @profiles = Profile.all
  #   render json: @profiles, status: :ok
  # end

  def me
    render json: current_resource_owner, serializer: UserSerializer, status: :ok
  end
end
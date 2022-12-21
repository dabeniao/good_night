class FollowingUsersController < ApplicationController

  before_action :find_target_user, only: [:update, :destroy]

  def update
    if current_user.follow(@target_user)
      render json: '', status: 200
    else
      render json: '', status: 422
    end
  end

  def destroy
    if current_user.unfollow(@target_user)
      render json: '', status: 200
    else
      render json: '', status: 422
    end
  end

  private
  def find_target_user
    @target_user = User.find_by(id: params[:id])
    if @target_user.nil?
      render json: '', status: 404
    end
  end
end

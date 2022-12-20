class FollowingUsersController < ApplicationController
  def update
    target_user = User.find_by(id: params[:id])
    if target_user.nil?
      render json: '', status: 404
      return
    end

    if current_user.follow(target_user)
      render json: '', status: 200
    else
      render json: '', status: 422
    end
  end

  def destroy
    target_user = User.find_by(id: params[:id])
    if target_user.nil?
      render json: '', status: 404
      return
    end

    if current_user.unfollow(target_user)
      render json: '', status: 200
    else
      render json: '', status: 422
    end
  end

end

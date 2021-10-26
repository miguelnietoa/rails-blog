# frozen_string_literal: true

# Users Controller
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = 'User created.'
      redirect_to root_path
    else
      render :new
    end
  end

  def follow
    @user = User.find(params[:id])
    current_user.followees << @user
    redirect_back(fallback: user_path(@user))
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.followed_users.find_by(followee_id: @user.id).destroy
    redirect_back(fallback_location: user_path(@user))
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :info)
  end
end

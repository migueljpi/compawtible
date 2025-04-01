class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
    @user = User.find(params[:id])
    @pets = @user.pets

    return unless @user.geocoded?

    @markers = [{
      lat: @user.latitude,
      lng: @user.longitude
    }]
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :age, :location, :about_me, :photo)
  end

  def set_user
    @user = User.find(params[:id])
  end
end

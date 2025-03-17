class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @pets = @user.pets

    @markers = [{
      lat: @user.latitude,
      lng: @user.longitude
    }] if @user.geocoded?
  end
end

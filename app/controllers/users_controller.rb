class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])

    @markers = [{
      lat: @user.latitude,
      lng: @user.longitude
    }] if @user.geocoded?
  end
end

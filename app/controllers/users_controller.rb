class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @pets = @user.pets

    return unless @user.geocoded?

    @markers = [{
      lat: @user.latitude,
      lng: @user.longitude
    }]
  end
end

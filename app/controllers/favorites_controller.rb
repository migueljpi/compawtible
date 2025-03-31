class FavoritesController < ApplicationController
  before_action :set_pet, only: %i[create destroy]

  def create
    current_user.favorite(@pet)
    respond_to do |format|
      format.html { redirect_to @pet }
      format.turbo_stream
    end
  end

  def destroy
    current_user.unfavorite(@pet)
    respond_to do |format|
      format.html { redirect_to @pet }
      format.turbo_stream
    end
  end

  private

  def set_pet
    @pet = Pet.find(params[:pet_id])
  end
end

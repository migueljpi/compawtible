class FavoritesController < ApplicationController
  before_action :set_pet, only: %i[create destroy]

  def create
    current_user.favorite(@pet)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @pet }
    end
  end

  def destroy
    favorite = current_user.favorites.find_by(favoritable: @pet)
    if favorite
      current_user.unfavorite(@pet)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @pet }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove("favorite_icon_#{@pet.id}") }
        format.html { redirect_to @pet }
      end
    end
  end

  private

  def set_pet
    @pet = Pet.find(params[:pet_id])
  end
end

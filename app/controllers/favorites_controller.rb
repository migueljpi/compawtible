class FavoritesController < ApplicationController
  before_action :set_pet, only: %i[create destroy]

  def create
    current_user.favorite(pet: @pet)
    # redirect_to request.referer || root_path, notice: "Pet was successfully favorited."
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @pet }
    end
  end

  def destroy
    current_user.unfavorite(@pet)
    # redirect_to request.referer || root_path, notice: "Pet was successfully unfavorited."
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @pet }
    end
  end

  private

  def set_pet
    @pet = Pet.find(params[:pet_id])
  end
end

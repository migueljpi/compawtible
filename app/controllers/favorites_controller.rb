class FavoritesController < ApplicationController
  before_action :set_pet, only: %i[create destroy]
  skip_after_action :verify_policy_scoped, only: [:create, :destroy]

  def create
    # authorize @user
    @favorite = Favorite.new
    @favorite.favoritor = current_user
    @favorite.favoritable = @pet
    authorize @favorite
    current_user.favorite(@pet)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @pet }
    end
  end

  def destroy
    # authorize User  # This makes sure that the user is authorized to access the index


    favorite = current_user.favorites.find_by(favoritable: @pet)
    authorize favorite
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

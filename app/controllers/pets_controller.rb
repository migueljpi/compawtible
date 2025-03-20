class PetsController < ApplicationController
  def index
    @pets = Pet.all
  end

  def show
    @pet = Pet.find(params[:id])
  end

  def new
    @pet = Pet.new
    @user = current_user
  end

  def create
    @pet = Pet.new(pet_params)
    @user = current_user
    @pet.provider = current_user
    @pet.location = current_user.location
    if @pet.save
      # redirect_to user_path(current_user)
      redirect_to pet_path(@pet)
      flash[:notice] = "Pet was successfully added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def pet_params
    params.require(:pet).permit(:name, :species, :breed, :description, :user_id, :photo, :age, :size, :activity_level, :gender, :neutered, :medical_conditions, :sociable_with_animals, :sociable_with_children, :certified)
  end
end

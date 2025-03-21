class PetsController < ApplicationController
  def index
    @pets = Pet.all
  end

  def show
    @user = current_user
    @pet = Pet.find(params[:id])
  end

  def new
    @pet = Pet.new
    @user = current_user
    @url_action = params[:action]
    @pet.location = current_user.location
  end

  def create
    @user = current_user
    @pet = Pet.new(pet_params)
    @pet.provider = current_user
    @pet.location = current_user.location
    if @pet.save
      # redirect_to user_path(current_user)
      redirect_to user_pet_path(@user, @pet)
      flash[:notice] = "Pet was successfully added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # raise
    @pet = Pet.find(params[:id])
    @user = current_user
    @url_action = params[:action]
  end

  def update
    @pet = Pet.find(params[:id])
    @user = current_user
    if @pet.update(pet_params)
      if params[:pet][:photos].present?
        params[:pet][:photos].each do |photo|
          @pet.photos.attach(photo)
        end
      end
      redirect_to user_pet_path(@user, @pet), notice: "#{@pet.name} was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def pet_params
    params.require(:pet).permit(:name, :species, :breed, :description, :location, :user_id, :age, :size, :activity_level, :gender, :neutered, :medical_conditions, :sociable_with_animals, :sociable_with_children, :certified)
  end
end

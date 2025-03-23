class PetsController < ApplicationController
  before_action :set_user, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :set_pet, only: [:show, :edit, :update, :destroy]


  def index
    @pets = Pet.all
  end

  def show
    @user = User.find(params[:user_id])
    @pet = @user.pets.find(params[:id])
  end

  def new
    @pet = Pet.new
    @url_action = params[:action]
    @pet.location = current_user.location
  end

  def create
    @pet = Pet.new(pet_params_new)
    @pet.provider = current_user
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
    @url_action = params[:action]
  end

  def update
    if @pet.update(pet_params_edit)
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

  def destroy
    Rails.logger.debug "params[:user_id]: #{params[:user_id]}"  # Print out the user_id to check
    @pet.destroy
    redirect_to user_path(@user), notice: 'Pet was successfully removed.'
  end

  private

  def set_user
    @user = current_user
  end

  def set_pet
    @pet = Pet.find(params[:id])
  end

  def pet_params_new
    params.require(:pet).permit(:name, :species, :breed, :description, :location, :user_id, :age, :size, :activity_level, :gender, :neutered, :medical_conditions, :sociable_with_animals, :sociable_with_children, :certified, photos: [])
  end

  def pet_params_edit
    params.require(:pet).permit(:name, :species, :breed, :description, :location, :user_id, :age, :size, :activity_level, :gender, :neutered, :medical_conditions, :sociable_with_animals, :sociable_with_children, :certified)
  end
end

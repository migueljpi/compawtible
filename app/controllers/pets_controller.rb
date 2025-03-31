class PetsController < ApplicationController
  before_action :set_user, only: %i[show new create edit update destroy]
  before_action :set_pet, only: %i[show edit update destroy favorite]

  def index
    @pets = Pet.all
  end

  def show
    # @user = User.find(params[:user_id])
    @pet = Pet.find(params[:id])
    @provider = @pet.provider

    return unless @pet.geocoded?

    @markers = [{
      lat: @pet.latitude,
      lng: @pet.longitude
    }]
  end

  def favorite
    current_user.favorite(@pet)
    redirect_to pet_path(@pet)
  end

  def new
    @pet = Pet.new
    @url_action = params[:action]
    @pet.location = current_user.location
    # @pet.skip_breed_validations = true
    # @pet.skip_description_validations = true
  end

  def create
    # raise
    @pet = Pet.new(pet_params_new)
    @pet.provider = current_user

    # @pet.skip_breed_validations = false
    # @pet.skip_description_validations = false

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
    # Rails.logger.debug "params[:user_id]: #{params[:user_id]}"  # Print out the user_id to check
    @pet.destroy
    # raise
    redirect_to user_path(@user), notice: 'Pet was successfully removed.'
  end

  def update_breeds
    @pet = Pet.new(species: pet_params_new[:pet][:species])
    render partial: "breeds_select", locals: { f: ActionView::Helpers::FormBuilder.new(:pet, @pet, self, {}) }
  end

  private

  def set_user
    @user = current_user
  end

  def set_pet
    @pet = Pet.find(params[:id])
  end

  def pet_params_new
    params.require(:pet).permit(:name, :species, :breed, :description, :location, :user_id, :age, :size,
                                :activity_level, :gender, :neutered, :medical_conditions, :sociable_with_animals, :sociable_with_children, :certified, photos: [])
  end

  def pet_params_edit
    params.require(:pet).permit(:name, :species, :breed, :description, :location, :user_id, :age, :size,
                                :activity_level, :gender, :neutered, :medical_conditions, :sociable_with_animals, :sociable_with_children, :certified)
  end
end

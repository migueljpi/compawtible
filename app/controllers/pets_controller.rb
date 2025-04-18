class PetsController < ApplicationController
  before_action :set_user, only: %i[show new create edit update destroy]
  before_action :set_pet, only: %i[show edit update destroy favorite]

  def index
    if params[:location].present? && params[:radius].present?
      coordinates = Geocoder.coordinates(params[:location])
      if coordinates.present?
        @pets = Pet.near(coordinates, params[:radius].to_i) # Filter pets within the radius
      else
        flash.now[:alert] = "Invalid location. Showing all pets."
        @pets = Pet.all
      end
    else
      @pets = Pet.all
    end

    if params[:query].present?
      @pets = @pets.search_by_name_and_species_age_size_gender_description_location_breed_activity_level_neutered(params[:query])
    end

    authorize @pets
    @pets = policy_scope(@pets)

    if request.format.turbo_stream?
      render turbo_stream: turbo_stream.replace("pets_list", partial: "pets/pets_list", locals: { pets: @pets })
    else
      render :index
    end
  end


  def show
    authorize @pet
    policy_scope(Pet)
    if params[:prompt_id].present?
      @prompt = Prompt.find(params[:prompt_id])
    end
    # @user = User.find(params[:user_id])
    # @pet = @user.pets.find(params[:id])
    @message = Message.new
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
    policy_scope(Pet)
    @url_action = params[:action]
    @pet.location = current_user.location
    authorize @pet
    # @pet.skip_breed_validations = true
    # @pet.skip_description_validations = true
  end

  def create
    # raise
    @pet = Pet.new(pet_params_new)
    @pet.provider = current_user

    authorize @pet
    policy_scope(Pet)

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
    # @pet = Pet.find(params[:id])
    # @user = @pet.user  # Assuming that each pet belongs to a user

    # This will check if the current user is allowed to edit the pet
    authorize @pet
    policy_scope(Pet)



    @url_action = params[:action]
  end

  def update
    # @pet = Pet.find(params[:id])
    # @user = @pet.user  # Assuming that each pet belongs to a user

    # Authorize the pet to ensure that the current user can update it
    authorize @pet
    policy_scope(Pet)

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
    authorize @pet
    policy_scope(Pet)
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

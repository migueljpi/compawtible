class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @text = Text.new
    @adoption_location = AdoptionLocation.new

    if request.post? # Handle form submission
      @text = Text.new(text_params)

      if @text.adoption_location.present?
        location = @text.adoption_location.location
        radius = @text.adoption_location.radius

        if location.present? && radius.present?
          @users_nearby = User.near(location, radius)
          @text.database = @users_nearby.map do |user|
            user.pets.map do |pet|
              { id: pet.id, name: pet.name, species: pet.species, breed: pet.breed, description: pet.description }
            end
          end.flatten.to_json

          if @text.save
            @output = @text.output # Call the output method here
            respond_to do |format|
              format.turbo_stream # Respond with Turbo Stream
              format.html { redirect_to root_path } # Fallback for non-Turbo requests
            end
          else
            flash.now[:alert] = "There was an error saving the data."
            render :home, status: :unprocessable_entity
          end
        else
          flash.now[:alert] = "Please provide both location and radius."
          render :home, status: :unprocessable_entity
        end
      else
        flash.now[:alert] = "AdoptionLocation data is missing."
        render :home, status: :unprocessable_entity
      end
    else
      @users = User.all
      @pets = Pet.all
    end
  end

  private

  def text_params
    params.require(:text).permit(:input, adoption_location_attributes: [:location, :radius])
  end
end

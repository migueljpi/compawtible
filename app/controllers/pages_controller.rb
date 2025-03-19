class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @prompt = Prompt.new
    @adoption_location = AdoptionLocation.new

    if request.post? # Handle form submission
      @prompt = Prompt.new(prompt_params)
      @prompt.user = current_user
      if @prompt.adoption_location.present?
        location = @prompt.adoption_location.location
        radius = @prompt.adoption_location.radius

        if location.present? && radius.present?
          # @users_nearby = User.near(location, radius)
          # @promtp.pets_for_prompt = @users_nearby.map do |user|
          #   user.pets.map do |pet|
          #     { id: pet.id, name: pet.name, species: pet.species, breed: pet.breed, description: pet.description }
          #   end
          # end.flatten.to_json
          @pets_nearby = Pet.near(location, radius)
          @prompt.pets_for_prompt = @pets_nearby.map do |pet|
            { id: pet.id, name: pet.name, species: pet.species, breed: pet.breed, description: pet.description }
          end.flatten.to_json
          if @prompt.save!
            @output = @prompt.output # Call the output method here
            respond_to do |format|
              format.turbo_stream # Respond with Turbo Stream
              format.html { redirect_to root_path } # Fallback for non-Turbo requests
            end
          else
            puts "IT DIDN'T SAVE!"
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

  def prompt_params
    params.require(:prompt).permit(:user_id, :input, adoption_location_attributes: [:location, :radius])
  end
end

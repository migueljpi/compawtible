class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @users = User.all
    @pets = Pet.all
    @prompt = Prompt.new

    if request.post?
      @prompt = Prompt.new(prompt_params)
      @prompt.user = current_user

      # Get location and radius from params
      location = params[:location]
      radius = params[:radius].to_i

      if location.present? && radius > 0
        @pets_nearby = Pet.near(location, radius)
        @prompt.pets_for_prompt = @pets_nearby.map do |pet|
          { id: pet.id, name: pet.name, species: pet.species, breed: pet.breed, description: pet.description, location: pet.location }
        end.flatten.to_json

        if @prompt.save
          @output = @prompt.output # OUTPUT
          respond_to do |format|
            format.turbo_stream # IN CASE IT IS A TURBO REQUEST
            format.html { redirect_to root_path } # IN CASE IT IS A REGULAR REQUEST (if we have not clicked submit yet for example)
          end
        else
          flash.now[:alert] = "There was an error saving the data."
          render :home, status: :unprocessable_entity
        end
      else
        flash.now[:alert] = "Please provide both location and radius."
        render :home, status: :unprocessable_entity
      end
    end
  end

  private

  def prompt_params
    params.require(:prompt).permit(:input, :pets_for_prompt) # Only permit input and pets_for_prompt
  end
end

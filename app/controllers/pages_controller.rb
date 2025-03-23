class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
  end

  def search
    @users = User.all
    @pets = Pet.all
    @prompt = Prompt.new

    return unless request.post?

    @prompt = Prompt.new(prompt_params)
    @prompt.user = current_user

    # Get location and radius from params
    location = params[:location]
    radius = params[:radius].to_i

    if location.present? && radius > 0
      @pets_nearby = FindPetsService.call(location, radius)
      @prompt.pets_for_prompt = @pets_nearby.to_json # PETS FOR PROMPT

      if @prompt.save
        @output = @prompt.output # OUTPUT
        Rails.logger.info("Prompt saved with output: " + @output) # for debuggin
        ids = JSON.parse(@output) # Parse the IDs
        @prompt.update(best_matches: ids) # Update the best_matches column with the IDs, to use later

        @best_matches = ids.map { |id| Pet.find_by(id: id) }.compact # PETS ID MATCHING THE OUTPUT, mapped

        respond_to do |format|
          format.turbo_stream # IN CASE IT IS A TURBO REQUEST
          # IN CASE IT IS A REGULAR REQUEST (if we have not clicked submit yet for example)
          format.html do
            redirect_to root_path
          end
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

  def other_matches
    @prompt = Prompt.find(params[:prompt_id])
    pet_ids = @prompt.best_matches

    @best_matches = pet_ids.map { |id| Pet.find_by(id: id) }.compact
  end

  private

  def prompt_params
    params.require(:prompt).permit(:input, :pets_for_prompt) # Only permit input and pets_for_prompt
  end
end

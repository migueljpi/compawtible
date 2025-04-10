class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :home, unless: :skip_pundit?
  skip_after_action :verify_policy_scoped, only: [:index]

  def home
    authorize :page, :home?
  end

  def index
  end

  def search
    @pet_facts = Pet.get_facts

    authorize :page, :search?
    if params[:prompt_id].present?
      @prompt = Prompt.find(params[:prompt_id])
      @output = @prompt.generate_output

      if @output.nil?
        @retry = true # Flag to indicate invalid response
        @best_matches = [] # No matches to display
      else
        ids = JSON.parse(@output)
        @best_matches = ids.map { |id| Pet.find_by(id: id) }.compact
      end
    else
      # Case 2: No prompt_id is provided, initialize a new prompt
      @prompt = Prompt.new
      @best_matches = [] # No matches to display yet

      if request.post?
        # Case 3: A new search is submitted
        @prompt = Prompt.new(prompt_params)
        @prompt.user = current_user

        # Get location and radius from params
        location = params[:location]
        radius = params[:radius].to_i

        if location.present? && radius > 0
          @pets_nearby = FindPetsService.call(location, radius)
          @prompt.pets_for_prompt = @pets_nearby.to_json # PETS FOR PROMPT

          if @prompt.save
            @output = @prompt.generate_output # Explicitly generate the output

            if @output.nil?
              @retry = true # Flag to indicate invalid response
              @best_matches = [] # No matches to display
            else
              Rails.logger.info("Prompt saved with output: " + @output)
              ids = JSON.parse(@output) # Parse the IDs
              @prompt.update(best_matches: ids) # Update the best_matches column with the IDs
              @best_matches = ids.map { |id| Pet.find_by(id: id) }.compact
            end

            # Render the Turbo Frame content
            countdown(3) # for presentation loading screen
            render turbo_frame: "output-three", partial: "pages/output_three", locals: { best_matches: @best_matches }
          else
            flash.now[:alert] = "There was an error saving the data."
            render :search, status: :unprocessable_entity
          end
        else
          flash.now[:alert] = "Please provide both location and radius."
          render :search, status: :unprocessable_entity
        end
      end
    end
  end

  def other_matches
    authorize :page, :other_matches?
    @prompt = Prompt.find(params[:prompt_id])
    pet_ids = @prompt.best_matches

    @best_matches = pet_ids.map { |id| Pet.find_by(id: id) }.compact
  end

  private

  def prompt_params
    params.require(:prompt).permit(:input, :pets_for_prompt) # Only permit input and pets_for_prompt
  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def countdown(seconds)
    seconds.times do |i|
      sleep(1)
      puts "#{seconds - i} seconds remaining..."
    end
  end
end

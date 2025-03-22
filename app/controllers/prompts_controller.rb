class PromptsController < ApplicationController

  def create
    @prompt = Prompt.new(prompt_params)
    @prompt.user = current_user
    # @prompt.pets_for_prompt = Pet.all.to_json # This will be changed later
    puts "THIS IS THE INPUT-----------------"
    puts @prompt.input
    puts "THIS IS THE DATABASE-----------------"
    puts @prompt.pets_for_prompt
    if @prompt.save
      puts "it saved"
      @input = @prompt.input
      @output = @prompt.output
      redirect_to root_path(output: @output, input: @input)
    else
      puts "it didn't save"
      render 'pages/home'
    end
  end


  private

  def prompt_params
    params.require(:prompt).permit(:input, :pets_for_prompt,  :user_id)
  end
end

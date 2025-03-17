class TextsController < ApplicationController

  def create
    @text = Text.new(text_params)
    @text.database = Pet.all.to_json # This will be changed later
    puts "THIS IS THE INPUT-----------------"
    puts @text.input
    puts "THIS IS THE DATABASE-----------------"
    puts @text.database
    if @text.save
      puts "it saved"
      @input = @text.input
      @output = @text.output
      redirect_to root_path(output: @output, input: @input)
    else
      puts "it didn't save"
      render 'pages/home'
    end
  end


  private

  def text_params
    params.require(:text).permit(:input)
  end
end

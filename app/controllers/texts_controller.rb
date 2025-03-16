class TextsController < ApplicationController

  def create
    @text = Text.new(text_params)
    puts @text.input
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

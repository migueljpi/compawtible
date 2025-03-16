class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @text = Text.new
    @output = params[:output]
  end

  def test
    @text = Text.new
  end
end

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @text = Text.new
    @text.database = Pet.all.to_json # This will be changed later
    @output = params[:output]
    @users = User.all

  end

  def test
    @text = Text.new
  end
end

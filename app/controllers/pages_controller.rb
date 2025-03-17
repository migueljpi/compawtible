class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @text = Text.new
    @text.database = Pet.all.to_json # This will be changed later
    @output = params[:output]
    @users = User.all

    location = params.dig(:adoption_location, :location)
    radius = params.dig(:adoption_location, :radius)

    if location.present? && radius.present?
      @users_nearby = User.near(location, radius)
    else
      @users_nearby = []
    end
  end

  def test
    @text = Text.new
  end
end

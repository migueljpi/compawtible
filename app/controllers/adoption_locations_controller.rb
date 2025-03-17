class AdoptionLocationsController < ApplicationController
  def create
    @adoption_location = AdoptionLocation.new(adoption_location_params)
    if @adoption_location.save
      puts "-------Adoption location saved------"
      redirect_to root_path
    else
      puts "-------Adoption location not saved------"
      render 'pages/home'
    end
  end

  private

  def adoption_location_params
    params.require(:adoption_location).permit(:location, :radius)
  end
end

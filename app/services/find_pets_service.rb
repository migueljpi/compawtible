class FindPetsService
  def self.call(location, radius)
    Rails.logger.info("FindPetsService called with location: #{location}, radius: #{radius}")

    # Geocode the location to get latitude and longitude
    coordinates = Geocoder.coordinates(location)
    Rails.logger.info("Geocoded coordinates for location '#{location}': #{coordinates.inspect}")

    if coordinates.present?
      Rails.logger.info("Using radius: #{radius}")
      Pet.near(coordinates, radius).map do |pet|
        { id: pet.id, species: pet.species, breed: pet.breed, description: pet.description }
      end
    else
      Rails.logger.warn("No coordinates found for location: #{location}")
      []
    end
  end
end

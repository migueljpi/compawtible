class FindPetsService
  def self.call(location, radius)
    Pet.near(location, radius).map do |pet|
      { id: pet.id, species: pet.species, breed: pet.breed, description: pet.description }
    end
  end
end

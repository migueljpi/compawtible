# Destroy existing records
puts "Destroying existing records..."
AdoptionLocation.destroy_all
Prompt.destroy_all
Pet.destroy_all
User.destroy_all
Interaction.destroy_all
puts "Existing records destroyed!"

COUNTRIES = [
  { name: "Portugal", cities: ["Lisbon", "Porto"], providers: ["João", "Ana"], adopter: "Miguel", last_name: "Silva" },
  { name: "Spain", cities: ["Madrid", "Barcelona"], providers: ["Carlos", "Maria"], adopter: "Javier", last_name: "García" },
  { name: "France", cities: ["Paris", "Lyon"], providers: ["Pierre", "Camille"], adopter: "Jean", last_name: "Dubois" },
  { name: "The Netherlands", cities: ["Amsterdam", "Rotterdam"], providers: ["Daan", "Emma"], adopter: "Lars", last_name: "Jansen" },
  { name: "Belgium", cities: ["Brussels", "Antwerp"], providers: ["Mathieu", "Elise"], adopter: "Benoît", last_name: "Dupont" },
  { name: "Luxembourg", cities: ["Luxembourg City", "Esch-sur-Alzette"], providers: ["Marc", "Anne"], adopter: "Luc", last_name: "Schmit" },
  { name: "Switzerland", cities: ["Zurich", "Geneva"], providers: ["Luca", "Sophie"], adopter: "Noah", last_name: "Müller" },
  { name: "Italy", cities: ["Rome", "Milan"], providers: ["Luca", "Giulia"], adopter: "Matteo", last_name: "Rossi" },
  { name: "United Kingdom", cities: ["London", "Manchester"], providers: ["James", "Sophie"], adopter: "Oliver", last_name: "Smith" },
  { name: "Ireland", cities: ["Dublin", "Cork"], providers: ["Liam", "Aoife"], adopter: "Sean", last_name: "O'Connor" }
]

puts "Creating users..."
COUNTRIES.each do |country|
  country_code = country[:name].downcase.gsub(" ", "")

  country[:cities].each_with_index do |city, index|
    provider_name = country[:providers][index]
    User.create!(
      email: "provider#{index + 1}.#{country_code}@provider.com",
      password: "123456",
      first_name: provider_name,
      last_name: country[:last_name],
      age: rand(25..60),
      location: city,
      role: "provider",
      about_me: "Passionate about pet adoption and finding animals a loving home."
    )
  end

  User.create!(
    email: "adopter.#{country_code}@adopter.com",
    password: "123456",
    first_name: country[:adopter],
    last_name: country[:last_name],
    age: rand(18..70),
    location: country[:cities].sample,
    role: "adopter",
    about_me: "Looking for a new furry friend to adopt!"
  )
end
puts "Users created!"

SPECIES = {
  "Dog" => ["Golden Retriever", "Saint Bernard", "Labrador Retriever", "German Shepherd", "Poodle", "Bulldog", "Beagle", "Chihuahua", "Dachshund", "Siberian Husky", "Boxer", "Doberman", "Shih Tzu", "Border Collie", "Great Dane", "Rottweiler", "Cocker Spaniel", "Pomeranian", "Maltese", "Australian Shepherd", "Other"],
  "Cat" => ["Siamese", "Persian", "Maine Coon", "Bengal", "Ragdoll", "British Shorthair", "Sphynx", "Abyssinian", "Scottish Fold", "Norwegian Forest Cat", "Russian Blue", "Birman", "Savannah", "Oriental Shorthair", "Turkish Angora", "Other"],
  "Rabbit" => ["Holland Lop", "Netherland Dwarf", "Flemish Giant", "Lionhead", "Rex", "Mini Lop", "English Angora", "French Lop", "Dutch", "Harlequin", "Other"],
  "Bird" => ["Canary", "Finch", "Budgerigar", "Cockatiel", "Lovebird", "Dove", "Pigeon", "Other"]
}

PET_NAMES = ["Buddy", "Luna", "Charlie", "Bella", "Max", "Daisy", "Rocky", "Milo", "Ruby", "Simba"]
PET_DESCRIPTIONS = [
  "A friendly and energetic companion who loves to play.",
  "Loves cuddles and is very affectionate.",
  "Enjoys long walks and being around people.",
  "A curious and intelligent pet that learns quickly.",
  "Gentle and loving, perfect for families.",
  "A quiet and observant pet, great for small apartments.",
  "Full of energy and always ready for an adventure.",
  "Loves attention and is great with children.",
  "A loyal and protective companion.",
  "Playful and loves interactive toys."
]

puts "Creating pets..."
User.where(role: "provider").each do |provider|
  2.times do
    species, breeds = SPECIES.to_a.sample
    Pet.create!(
      location: provider.location,
      provider: provider,
      name: PET_NAMES.sample,
      species: species,
      breed: breeds.sample,
      age: rand(1..10),
      size: ["Small", "Medium", "Large"].sample,
      activity_level: ["Low", "Moderate", "High"].sample,
      gender: ["Male", "Female"].sample,
      neutered: [true, false].sample,
      sociable_with_animals: [true, false].sample,
      sociable_with_children: [true, false].sample,
      certified: [true, false].sample,
      description: PET_DESCRIPTIONS.sample
    )
  end
end
puts "Pets created!"
puts "Seeded #{User.count} users and #{Pet.count} pets!"

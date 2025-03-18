AdoptionLocation.destroy_all
Text.destroy_all
Pet.destroy_all
User.destroy_all
Connection.destroy_all

# Create providers
providers = [
  { email: "provider1@provider.com", first_name: "John", last_name: "Doe", age: 30, location: "Zanzibar City, Zanzibar, Tanzania", about_me: "I love animals and help them find loving homes!" },
  { email: "provider2@provider.com", first_name: "Anna", last_name: "Schmidt", age: 35, location: "Berlin, Berlin, Germany", about_me: "Passionate about rescuing stray cats and finding them the perfect forever homes." },
  { email: "provider3@provider.com", first_name: "Luca", last_name: "Rossi", age: 42, location: "Milan, Lombardy, Italy", about_me: "Dedicated to rehabilitating abandoned dogs and giving them a second chance at happiness." },
  { email: "provider4@provider.com", first_name: "Sofia", last_name: "Fernandez", age: 28, location: "Madrid, Madrid, Spain", about_me: "I work with shelters to ensure every pet gets the care and love they deserve." },
  { email: "provider5@provider.com", first_name: "Oliver", last_name: "Dupont", age: 38, location: "Paris, Île-de-France, France", about_me: "Helping animals find new homes while advocating for responsible pet adoption." }
]

providers.each do |provider|
  User.create!(
    email: provider[:email],
    password: "123456",
    first_name: provider[:first_name],
    last_name: provider[:last_name],
    age: provider[:age],
    location: provider[:location],
    provider: true,
    about_me: provider[:about_me]
  )
end

# Create adopters
User.create!(
  email: "adopter1@adopter.com",
  password: "123456",
  first_name: "Luis",
  last_name: "Marín",
  age: 28,
  location: "Madrid, España",
  provider: false
)

User.create!(
  email: "adopter2@adopter.com",
  password: "123456",
  first_name: "Maria",
  last_name: "Fernandes",
  age: 28,
  location: "Lisbon, Portugal",
  provider: false,
  about_me: "I have always loved animals and am looking to adopt a furry friend to join my home."
)

# Assign each provider a unique cat and dog
provider_users = User.where(provider: true)

pets = [
  { species: "Dog", breed: "Golden Retriever", name: "Bobby", description: "Friendly and playful, Bobby loves to fetch and is great with kids." },
  { species: "Dog", breed: "Poodle", name: "Luna", description: "Smart and affectionate, Luna enjoys long walks and snuggles." },
  { species: "Dog", breed: "Labrador Retriever", name: "Max", description: "Energetic and adventurous, Max loves swimming and running outside." },
  { species: "Dog", breed: "Beagle", name: "Mia", description: "Curious and independent, Mia loves to explore and sniff around." },
  { species: "Dog", breed: "Border Collie", name: "Charlie", description: "Super intelligent and active, Charlie is great at learning new tricks." },
  { species: "Cat", breed: "Maine Coon", name: "Simba", description: "A fluffy and calm cat, Simba enjoys lounging and getting belly rubs." },
  { species: "Cat", breed: "Siamese", name: "Cleo", description: "Lively and talkative, Cleo loves climbing high places and playing with toys." },
  { species: "Cat", breed: "British Shorthair", name: "Whiskers", description: "A quiet and independent cat who loves cozy spots to nap in." },
  { species: "Cat", breed: "Persian", name: "Milo", description: "Sweet and affectionate, Milo enjoys gentle cuddles and relaxing." },
  { species: "Cat", breed: "Ragdoll", name: "Bella", description: "Friendly and social, Bella loves being around people and getting attention." }
]

provider_users.each_with_index do |provider, index|
  dog = pets[index]
  cat = pets[index + 5]

  Pet.create!(
    user: provider,
    name: dog[:name],
    species: dog[:species],
    breed: dog[:breed],
    age: rand(1..7),
    size: ["Small", "Medium", "Large"].sample,
    activity_level: ["Low", "Moderate", "High"].sample,
    gender: ["Male", "Female"].sample,
    neutered: [true, false].sample,
    sociable_with_animals: [true, false].sample,
    sociable_with_children: [true, false].sample,
    certified: [true, false].sample,
    description: dog[:description]
  )

  Pet.create!(
    user: provider,
    name: cat[:name],
    species: cat[:species],
    breed: cat[:breed],
    age: rand(1..7),
    size: ["Small", "Medium", "Large"].sample,
    activity_level: ["Low", "Moderate", "High"].sample,
    gender: ["Male", "Female"].sample,
    neutered: [true, false].sample,
    sociable_with_animals: [true, false].sample,
    sociable_with_children: [true, false].sample,
    certified: [true, false].sample,
    description: cat[:description]
  )
end



puts "Seeded #{User.count} users and #{Pet.count} pets!"

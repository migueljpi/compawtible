Pet.destroy_all
User.destroy_all
Connection.destroy_all

# Create user
provider = User.create!(
  email: "provider@provider.com",
  password: "123456",
  first_name: "John",
  last_name: "Doe",
  age: 30,
  location: "Zanzibar City, Zanzibar, Tanzania",
  provider: true,
  about_me: "I love animals and help them find loving homes!"
)

provider1 = User.create!(
  email: "anna.shelter@provider.com",
  password: "123456",
  first_name: "Anna",
  last_name: "Schmidt",
  age: 35,
  location: "Berlin, Berlin, Germany",
  provider: true,
  about_me: "Passionate about rescuing stray cats and finding them the perfect forever homes."
)

provider2 = User.create!(
  email: "luca.rescue@provider.com",
  password: "123456",
  first_name: "Luca",
  last_name: "Rossi",
  age: 42,
  location: "Milan, Lombardy, Italy",
  provider: true,
  about_me: "Dedicated to rehabilitating abandoned dogs and giving them a second chance at happiness."
)

provider3 = User.create!(
  email: "sofia.animals@provider.com",
  password: "123456",
  first_name: "Sofia",
  last_name: "Fernandez",
  age: 28,
  location: "Madrid, Madrid, Spain",
  provider: true,
  about_me: "I work with shelters to ensure every pet gets the care and love they deserve."
)

provider4 = User.create!(
  email: "oliver.pets@provider.com",
  password: "123456",
  first_name: "Oliver",
  last_name: "Dupont",
  age: 38,
  location: "Paris, Île-de-France, France",
  provider: true,
  about_me: "Helping animals find new homes while advocating for responsible pet adoption."
)

adopter1 = User.create!(
  email: "adopter1@adopter.com",
  password: "123456",
  first_name: "Luis",
  last_name: "Marín",
  age: 28,
  location: "Madrid, España",
  provider: false
)

adopter2 = User.create!(
  email: "adopter2@adopter.com",
  password: "123456",
  first_name: "Maria",
  last_name: "Fernandes",
  age: 28,
  location: "Lisbon, Portugal",
  provider: false,
  about_me: "I have always loved animals and am looking to adopt a furry friend to join my home."
)

pets = [
  { user_id: provider1.id, name: "Bobby", species: "Dog", breed: "Golden Retriever", age: 3, size: "Large", activity_level: "High", gender: "Male", neutered: true, sociable_with_animals: true, sociable_with_children: true, certified: false, description: "Bobby is an energetic and affectionate Golden Retriever who loves playing fetch at the beach. He is always eager to meet new people and other dogs. A loyal and loving companion for any active household." },
  { user_id: provider2.id, name: "Luna", species: "Dog", breed: "Poodle", age: 5, size: "Medium", activity_level: "Moderate", gender: "Female", neutered: true, sociable_with_animals: true, sociable_with_children: true, certified: true, description: "Luna is a sweet and intelligent Poodle with a gentle temperament. She enjoys long walks and cuddles on the couch. Her hypoallergenic coat makes her a great pet for allergy-sensitive owners." },
  { user_id: provider3.id, name: "Max", species: "Dog", breed: "Labrador Retriever", age: 2, size: "Large", activity_level: "High", gender: "Male", neutered: false, sociable_with_animals: true, sociable_with_children: true, certified: false, description: "Max is a playful and adventurous Labrador who loves swimming and running. He’s always up for a new challenge and enjoys learning new tricks. Perfect for an active family looking for a fun-loving pet." },
  { user_id: provider4.id, name: "Mia", species: "Dog", breed: "Beagle", age: 4, size: "Medium", activity_level: "Moderate", gender: "Female", neutered: true, sociable_with_animals: true, sociable_with_children: false, certified: false, description: "Mia is a curious Beagle with a great nose for adventure. She loves exploring new scents on her daily walks. She’s independent but loves snuggling up after a long day." },
  # { user_id: provider.id, name: "Simba", species: "Cat", breed: "Maine Coon", age: 3, size: "Large", activity_level: "Low", gender: "Male", neutered: true, sociable_with_animals: false, sociable_with_children: true, certified: false, description: "Simba is a majestic Maine Coon with a fluffy coat and a gentle nature. He loves lounging by the window and watching birds. A calm and affectionate companion for a quiet home." },
  # { user_id: provider.id, name: "Cleo", species: "Cat", breed: "Siamese", age: 2, size: "Medium", activity_level: "High", gender: "Female", neutered: true, sociable_with_animals: true, sociable_with_children: false, certified: false, description: "Cleo is a talkative and energetic Siamese who loves attention. She enjoys playing with feather toys and climbing high places. A perfect match for someone who wants a vocal and interactive pet." },
  # { user_id: provider.id, name: "Whiskers", species: "Cat", breed: "British Shorthair", age: 6, size: "Medium", activity_level: "Low", gender: "Male", neutered: true, sociable_with_animals: false, sociable_with_children: false, certified: false, description: "Whiskers is a dignified and independent British Shorthair. He prefers quiet spaces and enjoys watching the world go by from a cozy perch. A great pet for someone looking for a calm and low-maintenance companion." },
  # { user_id: provider.id, name: "Rocky", species: "Rabbit", breed: "Netherland Dwarf", age: 1, size: "Small", activity_level: "Moderate", gender: "Male", neutered: false, sociable_with_animals: false, sociable_with_children: true, certified: false, description: "Rocky is a tiny and playful Netherland Dwarf rabbit with a big personality. He enjoys hopping around and nibbling on fresh veggies. Perfect for a gentle and caring owner." },
  # { user_id: provider.id, name: "Blue", species: "Parrot", breed: "Macaw", age: 8, size: "Large", activity_level: "High", gender: "Male", neutered: false, sociable_with_animals: true, sociable_with_children: true, certified: true, description: "Blue is a vibrant Macaw with a talent for mimicking sounds. He loves engaging with people and showing off his colorful feathers. He needs a dedicated owner willing to provide plenty of social interaction." },
  # { user_id: provider.id, name: "Shelly", species: "Turtle", breed: "Red-Eared Slider", age: 5, size: "Small", activity_level: "Low", gender: "Female", neutered: false, sociable_with_animals: false, sociable_with_children: false, certified: false, description: "Shelly is a calm and quiet Red-Eared Slider who enjoys basking under the heat lamp. She requires minimal maintenance but loves fresh leafy greens. A great choice for someone looking for a peaceful pet." }
]

pets.each do |pet_attrs|
  Pet.create!(pet_attrs)
end

puts "Seeded #{User.count} users and #{Pet.count} pets!"

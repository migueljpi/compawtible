require "open-uri"
# Destroy existing records
puts "Destroying existing records..."
Prompt.destroy_all
Pet.destroy_all
User.destroy_all
Interaction.destroy_all
puts "Existing records destroyed!"

COUNTRIES = [
  { name: "Portugal", cities: ["Lisbon", "Porto"], provider_person: "João", provider_institution: "Lisbon Animal Rescue", adopter: "Miguel", last_name: "Silva" },
  { name: "Spain", cities: ["Madrid", "Barcelona"], provider_person: "Carlos", provider_institution: "Barcelona Pet Haven", adopter: "Javier", last_name: "García" },
  { name: "France", cities: ["Paris", "Lyon"], provider_person: "Pierre", provider_institution: "Paris Animal Shelter", adopter: "Jean", last_name: "Dubois" },
  { name: "The Netherlands", cities: ["Amsterdam", "Rotterdam"], provider_person: "Daan", provider_institution: "Rotterdam Animal Care", adopter: "Lars", last_name: "Jansen" },
  { name: "Belgium", cities: ["Brussels", "Antwerp"], provider_person: "Mathieu", provider_institution: "Brussels Pet Refuge", adopter: "Benoît", last_name: "Dupont" },
  { name: "Luxembourg", cities: ["Luxembourg City", "Esch-sur-Alzette"], provider_person: "Marc", provider_institution: "Luxembourg Animal Center", adopter: "Luc", last_name: "Schmit" },
  { name: "Switzerland", cities: ["Zurich", "Geneva"], provider_person: "Luca", provider_institution: "Swiss Pet Sanctuary", adopter: "Noah", last_name: "Müller" },
  { name: "Italy", cities: ["Rome", "Milan"], provider_person: "Luca", provider_institution: "Milan Rescue League", adopter: "Matteo", last_name: "Rossi" },
  { name: "United Kingdom", cities: ["London", "Manchester"], provider_person: "James", provider_institution: "London Animal Welfare", adopter: "Oliver", last_name: "Smith" },
  { name: "Ireland", cities: ["Dublin", "Cork"], provider_person: "Liam", provider_institution: "Cork Animal Rescue", adopter: "Sean", last_name: "O'Connor" }
]

puts "Creating users..."
COUNTRIES.each do |country|
  country_code = country[:name].downcase.gsub(" ", "")

  # Create a personal provider
  personal_provider = User.new(
    email: "provider1.#{country_code}@provider.com",
    password: "123456",
    first_name: country[:provider_person],
    last_name: country[:last_name],
    age: rand(25..60),
    location: country[:cities].first,
    role: "provider",
    about_me: "Passionate about pet adoption and finding animals a loving home."
  )

  file = File.open(Rails.root.join("app/assets/images/man2.jpg"))
  puts "man photo opened"
  puts "attaching photo"
  personal_provider.photo.attach(io: file, filename: "personal.jpg", content_type: "image/jpeg")
  puts "photo attached!"
  personal_provider.save!

  # Create an institutional provider
  institution = User.new(
    email: "provider2.#{country_code}@provider.com",
    password: "123456",
    first_name: country[:provider_institution],
    last_name: "Institution",
    age: rand(17..100),
    location: country[:cities].last,
    role: "provider",
    about_me: "A dedicated institution committed to rescuing and rehoming animals in need."
  )
  file = File.open(Rails.root.join("app/assets/images/shelter.jpg"))
  puts "sgelter photo opened"
  puts "attaching photo"
  institution.photo.attach(io: file, filename: "shelter.jpg", content_type: "image/jpeg")
  puts "photo attached!"
  institution.save!


  # Create an adopter
  adopter = User.new(
    email: "adopter.#{country_code}@adopter.com",
    password: "123456",
    first_name: country[:adopter],
    last_name: country[:last_name],
    age: rand(18..70),
    location: country[:cities].sample,
    role: "adopter",
    about_me: "Looking for a new furry friend to adopt!"
  )
  file = File.open(Rails.root.join("app/assets/images/man.jpg"))
  puts "man photo opened"
  puts "attaching photo"
  adopter.photo.attach(io: file, filename: "personal.jpg", content_type: "image/jpeg")
  puts "photo attached!"
  adopter.save!
end
puts "Users created!"

SPECIES = {
  "Dog" => ["Golden Retriever", "Saint Bernard", "Labrador Retriever"],
  "Cat" => ["Siamese", "Persian", "Maine Coon"],
  "Rabbit" => ["Holland Lop", "Netherland Dwarf"],
  "Chicken" => ["Rhode Island Red", "Leghorn"],
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
  "Playful and loves interactive toys.",
  "Loves belly rubs and naps in the sun. Always excited to meet new people!",
  "A gentle soul with a big heart. Enjoys snuggling on the couch.",
  "Full of playful energy but knows when to relax. Loves chasing toys!",
  "Sweet and curious, always exploring new places. Loves treats!",
  "A loyal companion who follows you everywhere. Loves long walks.",
  "Enjoys quiet afternoons and gentle head scratches. Purrs like a motor.",
  "A bundle of energy that never stops playing. Always up for an adventure!",
  "Shy at first but warms up quickly. Loves sitting by the window.",
  "Loves being the center of attention. Will do anything for a snack!",
  "Enjoys being around people but also loves solo time. Independent spirit!",
  "Always ready to greet you at the door. Loves morning cuddles.",
  "A little mischievous but endlessly charming. Loves playing hide and seek!",
  "Affectionate and gentle, perfect for a calm home. Loves chin scratches!",
  "Super smart and learns tricks quickly. Loves a good challenge!",
  "Gets along with everyone—humans, kids, and even other pets!",
  "A tiny explorer who loves sniffing out new adventures. Never stays still!",
  "Loves curling up in warm spots. Prefers blankets over beds!",
  "Friendly and goofy, always looking for fun. Loves chasing leaves!",
  "Quiet and thoughtful, but secretly a cuddle bug. Loves a cozy lap!",
  "Playful and energetic but enjoys lazy afternoons. Loves ear rubs!"
]

puts "Creating pets..."
User.where(role: "provider").each do |provider|
  # Ensure 2 pets are either a cat or a dog
  2.times do
    species = ["Dog", "Cat"].sample
    pet = Pet.new(
      location: provider.location,
      provider: provider,
      name: PET_NAMES.sample,
      species: species,
      breed: SPECIES[species].sample,
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
    if pet.breed == "Golden Retriever"
      puts "retrieving Golden Retriever photos"
      file = File.open(Rails.root.join("app/assets/images/dog1.jpg"))
      file2 = File.open(Rails.root.join("app/assets/images/golden retriever.jpg"))
      puts "file opened"
      puts "file2 opened"
      puts "attaching photos"
      pet.photos.attach([{io: file, filename: "golden retriever1.jpg", content_type: "image/jpeg"},
                        {io: file2, filename: "golden retriever2.jpg", content_type: "image/jpeg"}])
      puts "photos attached"
    elsif pet.breed == "Saint Bernard"
      puts "retrieving Saint Bernard photos"
      file = File.open(Rails.root.join("app/assets/images/saint bernard.jpg"))
      file2 = File.open(Rails.root.join("app/assets/images/saint bernard2.jpg"))
      puts "file opened"
      puts "file2 opened"
      puts "attaching photos"
      pet.photos.attach([{io: file, filename: "saint bernard1.jpg", content_type: "image/jpeg"},
                        {io: file2, filename: "saint bernard2.jpg", content_type: "image/jpeg"}])
      puts "photos attached"
    elsif pet.breed == "Labrador Retriever"
      puts "retrieving Saint Bernard photos"
      file = File.open(Rails.root.join("app/assets/images/labrador retriever.jpg"))
      file2 = File.open(Rails.root.join("app/assets/images/dog2.jpg"))
      puts "file opened"
      puts "file2 opened"
      puts "attaching photos"
      pet.photos.attach([{io: file, filename: "labrador retriever1.jpg", content_type: "image/jpeg"},
                        {io: file2, filename: "labrador retriever2.jpg", content_type: "image/jpeg"}])
      puts "photos attached"
    elsif pet.breed == "Siamese"
      puts "retrieving Saint Bernard photos"
      file = File.open(Rails.root.join("app/assets/images/siamese.jpg"))
      file2 = File.open(Rails.root.join("app/assets/images/siamese2.jpg"))
      puts "file opened"
      puts "file2 opened"
      puts "attaching photos"
      pet.photos.attach([{io: file, filename: "siamese1.jpg", content_type: "image/jpeg"},
                        {io: file2, filename: "siamese2.jpg", content_type: "image/jpeg"}])
      puts "photos attached"
    elsif pet.breed == "Persian"
      puts "retrieving Saint Bernard photos"
      file = File.open(Rails.root.join("app/assets/images/persian.jpg"))
      file2 = File.open(Rails.root.join("app/assets/images/persian2.jpg"))
      puts "file opened"
      puts "file2 opened"
      puts "attaching photos"
      pet.photos.attach([{io: file, filename: "persian1.jpg", content_type: "image/jpeg"},
                        {io: file2, filename: "persian2.jpg", content_type: "image/jpeg"}])
      puts "photos attached"
    elsif pet.breed == "Maine Coon"
      puts "retrieving Saint Bernard photos"
      file = File.open(Rails.root.join("app/assets/images/maine coon1.jpg"))
      file2 = File.open(Rails.root.join("app/assets/images/maine coon2.jpg"))
      puts "file opened"
      puts "file2 opened"
      puts "attaching photos"
      pet.photos.attach([{io: file, filename: "maine coon1.jpg", content_type: "image/jpeg"},
                        {io: file2, filename: "maine coon2.jpg", content_type: "image/jpeg"}])
      puts "photos attached"
    end
    pet.save!
  end

  # Ensure the other 2 pets are either a cat, dog, rabbit, or chicken
  2.times do
    species = ["Dog", "Cat", "Rabbit", "Chicken"].sample
    pet = Pet.create!(
      location: provider.location,
      provider: provider,
      name: PET_NAMES.sample,
      species: species,
      breed: SPECIES[species].sample,
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
    if pet.breed == "Golden Retriever"
      puts "retrieving Golden Retriever photos"
      file = File.open(Rails.root.join("app/assets/images/dog1.jpg"))
      file2 = File.open(Rails.root.join("app/assets/images/golden retriever.jpg"))
      puts "file opened"
      puts "file2 opened"
      puts "attaching photos"
      pet.photos.attach([{io: file, filename: "golden retriever1.jpg", content_type: "image/jpeg"},
                        {io: file2, filename: "golden retriever2.jpg", content_type: "image/jpeg"}])
      puts "photos attached"
    elsif pet.breed == "Saint Bernard"
      puts "retrieving Saint Bernard photos"
      file = File.open(Rails.root.join("app/assets/images/saint bernard.jpg"))
      file2 = File.open(Rails.root.join("app/assets/images/saint bernard2.jpg"))
      puts "file opened"
      puts "file2 opened"
      puts "attaching photos"
      pet.photos.attach([{io: file, filename: "saint bernard1.jpg", content_type: "image/jpeg"},
                        {io: file2, filename: "saint bernard2.jpg", content_type: "image/jpeg"}])
      puts "photos attached"
    elsif pet.breed == "Labrador Retriever"
      puts "retrieving Saint Bernard photos"
      file = File.open(Rails.root.join("app/assets/images/labrador retriever.jpg"))
      file2 = File.open(Rails.root.join("app/assets/images/dog2.jpg"))
      puts "file opened"
      puts "file2 opened"
      puts "attaching photos"
      pet.photos.attach([{io: file, filename: "labrador retriever1.jpg", content_type: "image/jpeg"},
                        {io: file2, filename: "labrador retriever2.jpg", content_type: "image/jpeg"}])
      puts "photos attached"
    elsif pet.breed == "Siamese"
      puts "retrieving Saint Bernard photos"
      file = File.open(Rails.root.join("app/assets/images/siamese.jpg"))
      file2 = File.open(Rails.root.join("app/assets/images/siamese2.jpg"))
      puts "file opened"
      puts "file2 opened"
      puts "attaching photos"
      pet.photos.attach([{io: file, filename: "siamese1.jpg", content_type: "image/jpeg"},
                        {io: file2, filename: "siamese2.jpg", content_type: "image/jpeg"}])
      puts "photos attached"
    elsif pet.breed == "Persian"
      puts "retrieving Saint Bernard photos"
      file = File.open(Rails.root.join("app/assets/images/persian.jpg"))
      file2 = File.open(Rails.root.join("app/assets/images/persian2.jpg"))
      puts "file opened"
      puts "file2 opened"
      puts "attaching photos"
      pet.photos.attach([{io: file, filename: "persian1.jpg", content_type: "image/jpeg"},
                        {io: file2, filename: "persian2.jpg", content_type: "image/jpeg"}])
      puts "photos attached"
    elsif pet.breed == "Maine Coon"
      puts "retrieving Saint Bernard photos"
      file = File.open(Rails.root.join("app/assets/images/maine coon1.jpg"))
      file2 = File.open(Rails.root.join("app/assets/images/maine coon2.jpg"))
      puts "file opened"
      puts "file2 opened"
      puts "attaching photos"
      pet.photos.attach([{io: file, filename: "maine coon1.jpg", content_type: "image/jpeg"},
                        {io: file2, filename: "maine coon2.jpg", content_type: "image/jpeg"}])
      puts "photos attached"
    elsif pet.breed == "Holland Lop"
      puts "retrieving Saint Bernard photos"
      file = File.open(Rails.root.join("app/assets/images/holland lop1.jpg"))
      file2 = File.open(Rails.root.join("app/assets/images/holland lop2.jpg"))
      puts "file opened"
      puts "file2 opened"
      puts "attaching photos"
      pet.photos.attach([{io: file, filename: "holland lop1.jpg", content_type: "image/jpeg"},
                        {io: file2, filename: "holland lop2.jpg", content_type: "image/jpeg"}])
      puts "photos attached"
    elsif pet.breed == "Netherland Dwarf"
      puts "retrieving Saint Bernard photos"
      file = File.open(Rails.root.join("app/assets/images/netherland dwarf.jpg"))
      file2 = File.open(Rails.root.join("app/assets/images/netherland dwarf2.jpg"))
      puts "file opened"
      puts "file2 opened"
      puts "attaching photos"
      pet.photos.attach([{io: file, filename: "netherland dwarf1.jpg", content_type: "image/jpeg"},
                        {io: file2, filename: "netherland dwarf2.jpg", content_type: "image/jpeg"}])
      puts "photos attached"
    elsif pet.breed == "Rhode Island Red"
      puts "retrieving Saint Bernard photos"
      file = File.open(Rails.root.join("app/assets/images/rhode island red chicken.jpg"))
      file2 = File.open(Rails.root.join("app/assets/images/rhode island red chicken2.jpg"))
      puts "file opened"
      puts "file2 opened"
      puts "attaching photos"
      pet.photos.attach([{io: file, filename: "rhode island red chicken1.jpg", content_type: "image/jpeg"},
                        {io: file2, filename: "rhode island red chicken2.jpg", content_type: "image/jpeg"}])
      puts "photos attached"
    elsif pet.breed == "Leghorn"
      puts "retrieving Saint Bernard photos"
      file = File.open(Rails.root.join("app/assets/images/leghorn1.jpg"))
      file2 = File.open(Rails.root.join("app/assets/images/Leghorn2.jpg"))
      puts "file opened"
      puts "file2 opened"
      puts "attaching photos"
      pet.photos.attach([{io: file, filename: "leghorn1.jpg", content_type: "image/jpeg"},
                        {io: file2, filename: "leghorn2.jpg", content_type: "image/jpeg"}])
      puts "photos attached"
    end
    pet.save!
  end
end
puts "Pets created!"
puts "Seeded #{User.count} users and #{Pet.count} pets!"

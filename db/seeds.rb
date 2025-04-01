require "open-uri"
# Destroy existing records
puts "Destroying existing records..."
Chatroom.destroy_all
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
  "A friendly and energetic companion who loves to play. Always ready for a game of fetch or a run in the park. Gets along well with other pets and people alike. Thrives in an active household that can match its enthusiasm. After a long day, enjoys snuggling up close for some quality bonding time.",
  "Loves cuddles and is very affectionate. This pet will follow you around the house and snuggle up at every opportunity. A true lap companion who adores human interaction. Enjoys gentle belly rubs and will nuzzle up to you for extra attention. If you’re looking for a constant companion, this one will never leave your side.",
  "Enjoys long walks and being around people. Whether it’s a hike or a simple neighborhood stroll, this pet is happiest by your side. Friendly and sociable with both adults and children. Loves exploring new places and sniffing out exciting scents. Always eager to greet new people with a wagging tail and a happy demeanor.",
  "A curious and intelligent pet that learns quickly. Always eager to explore new environments and figure out puzzles. Training sessions are a breeze because of this pet's sharp mind. Needs mental stimulation to stay happy, such as interactive toys or puzzle feeders. Will impress you with its cleverness and problem-solving skills.",
  "Gentle and loving, perfect for families. This pet is patient with kids and enjoys a calm household. Loves to relax next to you after a day of gentle play. Enjoys being brushed or petted and will happily sit by your side for hours. Will always brighten your day with a sweet and loving personality.",
  "A quiet and observant pet, great for small apartments. Prefers watching from a cozy spot but enjoys short bursts of playtime. Independent yet affectionate when the moment is right. Enjoys lounging in sunny spots and observing the world from a distance. Loves gentle attention but won’t demand constant interaction.",
  "Full of energy and always ready for an adventure. Whether it’s hiking, running, or playing in the backyard, this pet never runs out of stamina. Needs an active home that loves to have fun. Always curious about new surroundings and eager to try new experiences. Makes a fantastic partner for an active lifestyle.",
  "Loves attention and is great with children. Always excited to greet new people with a wagging tail or happy purr. Makes a wonderful playmate and a loyal companion. Enjoys interactive playtime and will bring you toys when ready for fun. Will always be the first to welcome you home with excitement.",
  "A loyal and protective companion. Always keeps an eye on their family and alerts them to anything unusual. Despite their protective nature, they are affectionate and gentle with loved ones. Bonds deeply with their humans and thrives in a home that appreciates their devotion. Always eager to keep their family safe and happy.",
  "Playful and loves interactive toys. Can spend hours chasing a ball or solving a treat puzzle. Always up for a game and enjoys engaging with humans and pets alike. Prefers toys that challenge its mind and keep it entertained. Will always make you laugh with silly antics and joyful energy.",
  "Loves belly rubs and naps in the sun. Always excited to meet new people! This pet enjoys lazy afternoons but is equally happy playing when the mood strikes. Loves stretching out on a cozy bed and soaking up warmth. Will always greet you with a happy face and a wagging tail.",
  "A gentle soul with a big heart. Enjoys snuggling on the couch. Loves a quiet home where they can relax and be pampered with love and affection. A perfect match for someone who enjoys peaceful companionship. Will happily rest beside you and provide endless comfort.",
  "Full of playful energy but knows when to relax. Loves chasing toys! After an active play session, this pet is happy to curl up and snooze the rest of the day away. Enjoys a routine with plenty of exercise followed by quiet time. Always ready for the next adventure when the time comes.",
  "Sweet and curious, always exploring new places. Loves treats! This pet will keep you entertained with its funny antics and eagerness to discover the world. Will follow its nose to new scents and investigate every corner. A natural explorer who enjoys a bit of adventure.",
  "A loyal companion who follows you everywhere. Loves long walks. Whether you're cooking, reading, or working, expect this pet to be right beside you, offering silent support. Develops deep connections with its family and never wants to be left out. Always willing to join you for any activity.",
  "Enjoys quiet afternoons and gentle head scratches. Purrs like a motor. The perfect choice for someone who wants a relaxed and affectionate pet to keep them company. Loves curling up in a cozy spot and dozing the day away. Always appreciative of a calm and loving environment.",
  "A bundle of energy that never stops playing. Always up for an adventure! Perfect for an active household that enjoys exploring the outdoors together. Loves a game of tug-of-war or a run through the park. Will bring endless joy and excitement to your home.",
  "Shy at first but warms up quickly. Loves sitting by the window. Once comfortable, this pet will become your shadow, always curious about what you're up to. Enjoys gentle encouragement and patience from their humans. Blossoms into an affectionate and devoted companion.",
  "Loves being the center of attention. Will do anything for a snack! From showing off tricks to cuddling on demand, this pet knows how to win hearts. Enjoys being praised and will do whatever it takes to make you smile. Has a natural charm that makes everyone fall in love.",
  "Enjoys being around people but also loves solo time. Independent spirit! Prefers to set their own schedule but always comes back for love and attention. A great match for someone who respects their need for occasional solitude. Thrives in a home that gives them the perfect balance of affection and freedom.",
  "Always ready to greet you at the door. Loves morning cuddles. Starts every day with enthusiasm and affection, making every morning a little brighter. Enjoys routine and looks forward to daily playtime. The perfect companion for someone who loves a happy start to the day.",
  "A little mischievous but endlessly charming. Loves playing hide and seek! Whether it's hiding behind furniture or sneaking up on toys, this pet loves to surprise you. Always finding new ways to entertain and make life fun. Keeps the household lively with its playful tricks.",
  "Affectionate and gentle, perfect for a calm home. Loves chin scratches! A low-maintenance companion who just wants to be loved and pampered. Prefers quiet moments of affection and will happily curl up beside you. Always grateful for attention and love.",
  "Super smart and learns tricks quickly. Loves a good challenge! Always eager to impress and thrives on engaging training sessions with their favorite human. Enjoys mental stimulation as much as physical activity. A perfect choice for someone who loves teaching new skills.",
  "Gets along with everyone—humans, kids, and even other pets! A true social butterfly who is happiest when surrounded by love and activity. Loves making new friends and always wants to be part of the fun. Will brighten up any home with its joyful presence.",
  "A tiny explorer who loves sniffing out new adventures. Never stays still! Every walk turns into an exciting mission to discover new sights and smells. Loves the thrill of discovering hidden corners and surprises. Perfect for someone who enjoys an adventurous little spirit.",
  "Loves curling up in warm spots. Prefers blankets over beds! This pet enjoys cozy naps and will always find the warmest corner of the house to relax. Loves snuggling under soft covers and feeling safe. A professional napper with a heart full of love.",
  "Friendly and goofy, always looking for fun. Loves chasing leaves! Their playful and silly nature brings laughter and joy to every moment. Always the first to start a game and the last to stop. Makes every day a little brighter with endless enthusiasm.",
  "Quiet and thoughtful, but secretly a cuddle bug. Loves a cozy lap! Prefers a peaceful environment but never misses a chance for affection. Will patiently wait for attention and then melt into your arms. A sweet soul who values love and trust.",
  "Playful and energetic but enjoys lazy afternoons. Loves ear rubs! Balances excitement and calmness, making them the perfect all-around pet. Always happy to play but also appreciates quiet bonding moments. Will be your best friend through every mood and moment."
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

puts "Creating chatrooms..."
User.where(role: "adopter").each do |adopter|
  provider = User.where(role: "provider").sample
  pet = Pet.all.sample
  next unless provider && pet

  chatroom = Chatroom.create!(
    name: "Chat between #{adopter.first_name} and #{provider.first_name} about #{pet.name}",
    pet_id: pet.id
  )
  puts "Chatroom created: #{chatroom.name} (Pet: #{pet.name})"

  Message.create!(
    chatroom: chatroom,
    user: adopter,
    content: "Hello, I'm interested in #{pet.name}!"
  )
  Message.create!(
    chatroom: chatroom,
    user: provider,
    content: "hi #{adopter.first_name}, i can tell you more about #{pet.name}!"
  )
  13.times do |i|
    sender = [adopter, provider].sample
    Message.create!(
      chatroom: chatroom,
      user: sender,
      content: "Example message nº#{i + 3} from #{sender.first_name}"
    )
  end
  puts "15 messages  created on chatroom: #{chatroom.name}"
end
puts "Chatrooms and messages created"

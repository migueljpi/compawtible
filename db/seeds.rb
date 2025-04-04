require "open-uri"

# METHODS START
def cycle_through_array(array)
  @cycled_arrays ||= {}
  key = array.object_id

  if @cycled_arrays[key].nil? || @cycled_arrays[key].empty?
    @cycled_arrays[key] = array.shuffle
  end

  @cycled_arrays[key].pop
end
# METHODS END




# Destroy existing records
puts "Destroying existing records..."
Chatroom.destroy_all
Prompt.destroy_all
Pet.destroy_all
User.destroy_all
Interaction.destroy_all
puts "Existing records destroyed!"

COUNTRIES = [
  { name: "Portugal", cities: ["Rua Eça De Quiróz, 2670-652 Bucelas, Lisbon, Portugal", "Rua Da Praia, 4485-495 Mindelo, Porto, Portugal"], provider_person: "João", provider_institution: "Hopeful Paws", adopter: "Miguel", last_name: "Silva", adopter_city: "Lisbon" },
  { name: "Spain", cities: ["Avenida De La Estación, 28970 Humanes de Madrid, Madrid, Spain", "Avinguda Pau Clarís, 08760 Martorell, Barcelona, Spain"], provider_person: "Carlos", provider_institution: "Haven for Pets", adopter: "Javier", last_name: "García", adopter_city: "Lisbon" },
  { name: "France", cities: ["Rue De Limours, 91470 Limours, France", "Rue Des Dîmes, 69250 Montanay, France"], provider_person: "Pierre", provider_institution: "Compassionate Tails", adopter: "Jean", last_name: "Dubois", adopter_city: "Lyon" },
  { name: "The Netherlands", cities: ["Bovenkerkerweg, 1188 XH Amstelveen, Netherlands", "2e Tochtweg, 2913 LS Nieuwerkerk aan den IJssel, Netherlands"], provider_person: "Daan", provider_institution: "Safe Haven Rescue", adopter: "Lars", last_name: "Jansen", adopter_city: "Amsterdam" },
  { name: "Belgium", cities: ["Leyburgstraat, 1651 Beersel, Flemish Brabant, Belgium", "Boechoutsesteenweg, 2150 Borsbeek, Antwerp, Belgium"], provider_person: "Mathieu", provider_institution: "Kindred Hearts", adopter: "Benoît", last_name: "Dupont", adopter_city: "Ghent" },
  { name: "Luxembourg", cities: ["Rue Jean-Pierre Thill, 4924 Hautcharage, Luxembourg", "Rue Du Moulin, 7423 Dondelange, Luxembourg"], provider_person: "Marc", provider_institution: "New Beginnings Animal", adopter: "Luc", last_name: "Schmit", adopter_city: "Luxembourg City" },
  { name: "Switzerland", cities: ["Drisglerstrasse, 8107 Buchs, Switzerland", "Route De Soral, 1233 Bernex, Switzerland"], provider_person: "Luca", provider_institution: "Forever Home Rescue", adopter: "Noah", last_name: "Müller", adopter_city: "Zurich" },
  { name: "Italy", cities: ["Via Leonida Magnolini, 00123 Roma Rome, Italy", "Cascina Molino Mora, 20050 Liscate Milan, Italy"], provider_person: "Luca", provider_institution: "Paws & Claws", adopter: "Matteo", last_name: "Rossi", adopter_city: "Genova" },
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
    last_name: "Shelter",
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
    location: country[:adopter_city],
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

BREED_PHOTOS = {
  "Golden Retriever" => ["dog1.jpg", "golden retriever.jpg"],
  "Saint Bernard" => ["saint bernard.jpg", "saint bernard2.jpg"],
  "Labrador Retriever" => ["labrador retriever.jpg", "labrador retriever2.jpg"],
  "German Shepherd" => ["german shepherd.jpg", "german shepherd2.jpg"],
  "Beagle"  => ["beagle.jpg", "beagle2.jpg"],
  "Chihuahua" => ["chihuahua.jpg", "chihuahua2.jpg"],
  "Siamese" => ["siamese.jpg", "siamese2.jpg"],
  "Persian" => ["persian.jpg", "persian2.jpg"],
  "Maine Coon" => ["maine coon1.jpg", "maine coon2.jpg"],
  "Sphynx"  => ["sphynx.jpg", "sphynx2.jpg"],
  "Holland Lop" => ["holland lop1.jpg", "holland lop2.jpg"],
  "Netherland Dwarf" => ["netherland dwarf.jpg", "netherland dwarf2.jpg"],
  "Syrian Hamster" => ["syrian.jpg", "syrian2.jpg"],
  "American"  => ["american.jpg", "american2.jpg"],
  "Abyssinian" => ["abyssinian.jpg", "abyssinian2.jpg"],
  "Standard" => ["standard.jpg", "standard2.jpg"],
  "Canary" => ["canary.jpg", "canary2.jpg"],
  "Cockatiel" => ["cockatiel.jpg", "cockatiel2.jpg"],
  "Red-Eared Slider" => ["red-eared slider.jpg", "red-eared slider2.jpg"],
  "Box Turtle" => ["box turtle.jpg", "box turtle2.jpg"],
  "Betta" => ["betta.jpg", "betta2.jpg"],
  "Goldfish" => ["goldfish.jpg", "goldfish2.jpg"],
  "Koi" => ["koi.jpg", "koi2.jpg"],
  "Fancy Mouse" => ["fancy.jpg", "fancy2.jpg"],
  "Standard Gray" => ["chinchilla.jpg", "chinchilla2.jpg"],
  "Bearded Dragon" => ["bearded dragon.jpg", "bearded dragon2.jpg"],
  "Green Iguana" => ["green iguana.jpg", "green iguana2.jpg"],
  "Nubian" => ["nubian.jpg", "nubian2.jpg"],
  "Rhode Island Red" => ["rhode island red chicken.jpg", "rhode island red chicken2.jpg"],
  "Leghorn" => ["leghorn1.jpg", "Leghorn2.jpg"]
}

STRAY_PHOTOS = {
  "Dog" => {
    "Other" => [["strayA.jpg", "strayA2.jpg"], ["strayB.jpg", "strayB2.jpg"], ["strayC.jpg", "strayC2.jpg"], ["strayD.jpg", "strayD2.jpg"], ["strayE.jpg", "strayE2.jpg", "strayE3.jpg", "strayE4.jpg"],
                ["strayF.jpg", "strayF2.jpg"], ["strayG.jpg", "strayG2.jpg"], ["strayH.jpg", "strayH2.jpg"], ["strayI.jpg", "strayI2.jpg", "strayI3.jpg"], ["strayJ.jpg", "strayJ2.jpg"], ["strayK.jpg", "strayK2.jpg", "strayK3.jpg"],
                ["strayL.jpg", "strayL2.jpg", "strayL3.jpg"], ["strayM.jpg", "strayM2.jpg", "strayM3.jpg"]],
  },
  "Cat" => {
    "Other" => [["strayA.jpg", "strayA2.jpg", "strayA3.jpg"], ["strayB.jpg", "strayB2.jpg", "strayB3.jpg"], ["strayC.jpg", "strayC2.jpg"], ["strayD.jpg", "strayD2.jpg", "strayD3.jpg"],
                ["strayE.jpg", "strayE2.jpg"], ["strayF.jpg", "strayF2.jpg", "strayF3.jpg"], ["strayG.jpg", "strayG2.jpg", "strayG3.jpg"], ["strayH.jpg", "strayH2.jpg"], ["strayI.jpg", "strayI2.jpg"],
                ["strayJ.jpg", "strayJ2.jpg", "strayJ3.jpg"], ["strayK.jpg", "strayK2.jpg", "strayK3.jpg"], ["strayL.jpg", "strayL2.jpg", "strayL3.jpg"]],
  }
}

SPECIES = {
  "Dog" => ["Golden Retriever", "Saint Bernard", "Labrador Retriever", "German Shepherd", "Beagle", "Chihuahua",  "Other"],
  "Cat" => ["Siamese", "Persian", "Maine Coon", "Sphynx", "Other"],
  "Rabbit" => ["Holland Lop", "Netherland Dwarf", "Other"],
  "Hamster" => ["Syrian Hamster", "Dwarf Campbell Russian Hamster", "Other"],
  "Guinea pig" => ["American", "Abyssinian", "Other"],
  "Ferret" => ["Standard", "Other"],
  "Bird" => ["Canary", "Cockatiel", "Other"],
  "Turtle" => ["Red-Eared Slider", "Box Turtle", "Other"],
  "Fish" => ["Betta", "Goldfish", "Koi", "Other"],
  "Mouse" => ["Fancy Mouse", "Other"],
  "Chinchilla" => ["Standard Gray", "Other"],
  "Lizard" => ["Bearded Dragon", "Green Iguana", "Other"],
  "Goat" => ["Nubian", "Other"],
  "Chicken" => ["Rhode Island Red", "Leghorn", "Silkie", "Other"],
}

BREED_SIZES = {
  "Dog" => {
    "Chihuahua" => "Small", "Beagle" => "Medium", "Labrador Retriever" => "Large", "German Shepherd" => "Large", "Golden Retriever" => "Large", "Saint Bernard" => "Large", "Other" => "Medium"
  },
  "Cat" => {
    "Siamese" => "Small", "Maine Coon" => "Large", "Persian" => "Medium", "Sphynx" => "Medium", "Other" => "Medium"
  },
  "Rabbit" => {
    "Netherland Dwarf" => "Small", "Holland Lop" => "Medium", "Other" => "Medium"
  },
  "Hamster" => {
    "Syrian Hamster" => "Medium", "Dwarf Campbell Russian Hamster" => "Small", "Other" => "Medium"
  },
  "Guinea pig" => {
    "American" => "Medium", "Abyssinian" => "Medium", "Other" => "Medium"
  },
  "Ferret" => {
    "Standard" => "Medium", "Other" => "Medium"
  },
  "Bird" => {
    "Canary" => "Small", "Cockatiel" => "Medium", "Other" => "Medium"
  },
  "Turtle" => {
    "Red-Eared Slider" => "Medium", "Box Turtle" => "Medium", "Other" => "Medium"
  },
  "Fish" => {
    "Betta" => "Small", "Goldfish" => "Medium", "Koi" => "Large", "Other" => "Medium"
  },
  "Mouse" => {
    "Fancy Mouse" => "Small", "Other" => "Medium"
  },
  "Chinchilla" => {
    "Standard Gray" => "Medium", "Other" => "Medium"
  },
  "Lizard" => {
    "Bearded Dragon" => "Medium", "Green Iguana" => "Large", "Other" => "Medium"
  },
  "Goat" => {
    "Nubian" => "Large", "Other" => "Medium"
  },
  "Chicken" => {
    "Silkie" => "Small", "Rhode Island Red" => "Medium", "Leghorn" => "Medium", "Other" => "Medium"
  }
}

DESCRIPTIONS = {
  "Dog" => [
    "Chases balls with enthusiasm, but just as happy flopped at someone's feet. Loves meeting new people, going on walks, and soaking up attention—especially belly rubs.",
    "Affectionate goofball with a passion for zoomies, naps, and full-body tail wags. Lives for playtime and cozy couch time.",
    "Curious and always ready for the next thing. Whether it's a long walk, a car ride, or just sniffing around the garden, every day is an adventure.",
    "Couch potato *and* hiking buddy. Loves energetic runs just as much as lazy naps. Always eager to be part of the action, especially when treats are nearby.",
    "Gentle soul with a soft spot for cuddles. Sticks close by, enjoys ear scratches, and keeps a keen eye on every snack situation.",
    "Big eyes always watching, waiting for the next outing. Loves muddy puddles, clean towels, and greeting familiar faces like long-lost friends.",
    "Big personality with a lot to say. Loves warm laps, barking at imaginary intruders, and acting like the boss of the house.",
    "Calm and patient, with a comforting presence. Enjoys leaning in for affection and lounging like a furry weighted blanket.",
    "Always sniffing, always exploring. Finds joy in every stick, every breeze, every corner of the park.",
    "Awkward in the cutest way. Thinks every lap is the perfect size. Loves routines, soft toys, and sticking close to the humans.",
    "Always on patrol, always alert—except during nap time. Loves morning walks, squeaky toys, and flopping over dramatically for belly rubs like it’s a full-time job.",
    "Knows how to keep things interesting. One minute chasing leaves, the next curled up snoring like a log. Lives for treats, ear scratches, and sticking close to the action.",
    "Endlessly loyal and just a little goofy. Loves routine, greeting guests like long-lost friends, and flopping on the floor mid-play like a fuzzy sack of potatoes.",
    "Tail wags like a metronome when the leash comes out. Loves exploring new trails, checking every scent twice, and celebrating the return home like it’s a hero’s welcome.",
    "Eager face, wiggly body, heart of gold. Enjoys chasing shadows, stealing socks, and collapsing into a pile of contentment the moment the zoomies wear off."
  ],
  "Cat" => [
    "Curious and independent, but always ready for a quiet cuddle when the mood strikes. Prefers high perches and sunny nap spots.",
    "Playful little mischief-maker. Bats at anything that moves, explores every corner, then curls up like nothing ever happened.",
    "Purrs at the lightest touch, stretches out in warm spots, and spends hours watching the world from the windowsill.",
    "Sassy, smart, and full of personality. Loves hide-and-seek, dramatic stares, and turning cardboard boxes into fortresses.",
    "Life is never dull with this one. Chases toy mice, claims every soft blanket, and always finds the coziest nap spot—often the comfiest chair.",
    "Soft as a cloud with a flair for drama. Yells for food, walks away mid-bite, then naps in fresh laundry like royalty.",
    "Appears instantly at the sound of a tuna can. Enjoys head boops, warm laps, and uninvited bathroom visits.",
    "Slow to warm up, but deeply loyal once settled. Loves quiet company, chin scratches, and naps by the feet like a little guardian.",
    "Stealthy and fast. Enjoys midnight zoomies, blanket ambushes, and pretending not to care while secretly caring a lot.",
    "All about the vibes. Prefers calm mornings, bird-watching, and stretching dramatically in sunbeams like a feline model.",
    "Moves like a shadow and disappears just as easily. Finds the tiniest box, the sunniest spot, and the loudest way to announce dinner should’ve happened 10 minutes ago.",
    "Every curtain, shelf, and bag is fair game. Naps like a professional, watches birds with laser focus, and makes a sport out of knocking pens off the table.",
    "Expert-level napper with a love for chaos. A single crinkle can trigger full zoomies, followed by a perfectly timed stretch in the middle of a freshly made bed.",
    "Greets the day with a slow blink and dramatic stretch. Prefers windowsills to laps, climbs like gravity doesn’t exist, and always finds the warmest, softest thing in the room.",
    "Silent most of the time—until suddenly not. Enjoys sneaky shoulder taps, blank stares from across the room, and claiming every cardboard box as personal property."
  ],
  "Rabbit" => [
    "Loves to zoom around the room, then flop over dramatically for a nap. Always on the lookout for a tasty snack, especially fresh greens, and enjoys gentle head rubs after playtime.",
    "Curious and full of energy, always eager to explore new spaces. Has a soft spot for tunnels and cardboard boxes and will happily nudge your hand for attention when feeling affectionate.",
    "A quiet but playful companion who loves binkying across the floor. Can spend hours nibbling on hay, rearranging blankets, and finding the coziest corner to stretch out and relax.",
    "Takes treat time very seriously and will do a happy little hop when excited. Enjoys lounging in the sun, digging at blankets, and following favorite humans around for extra attention.",
    "Prefers a calm environment but always happy to show off a few playful hops. Loves chewing on wooden toys, burrowing into soft bedding, and having a quiet, cozy place to relax."
  ],
  "Hamster" => [
    "Loves to stuff those adorable cheeks with food and then scurry off to hide it. Nighttime is playtime, with plenty of wheel running, tunnel digging, and tiny adventures around the cage.",
    "Always busy rearranging bedding and making the perfect little nest. A bit shy at first but warms up quickly, especially when treats are involved. Loves exploring new hideouts and tunnels.",
    "A tiny ball of energy that never seems to stop moving. Will happily run miles on the wheel before curling up in a cozy corner for a nap. Loves foraging for hidden treats and snacks.",
    "Spends most of the day snoozing but comes alive in the evening, ready to dig, climb, and explore. A gentle and curious little companion who enjoys the occasional snack straight from your hand.",
    "Has a talent for finding the best hiding spots and loves to burrow deep into bedding. Always excited to see a tasty treat and enjoys a good climb, whether it's on toys or the cage bars!"
  ],
  "Guinea pig" => [
    "Always excited for mealtime and will let you know with the cutest little squeaks. Loves to explore tunnels, snuggle in soft bedding, and spend time with a buddy for company.",
    "Loves to lounge in cozy hideouts but gets bursts of energy, zooming around with excitement. A social little friend who enjoys gentle pets and the occasional snack straight from your hand.",
    "Chatty and full of personality, always wheeking for treats or attention. Enjoys munching on fresh veggies, burrowing into hay, and spending time with a trusted human or guinea pig friend.",
    "Curious but cautious, always sniffing around before making a move. Loves gentle handling and will happily settle in for a cuddle once comfortable. Fresh greens and soft bedding are a must!",
    "Full of charm and always up for a snack. Loves to popcorn around the enclosure when happy and enjoys being part of the daily routine, especially when it involves food or a bit of attention."
  ],
  "Ferret" => [
    "A mischievous little explorer who loves to sneak into every nook and cranny. Whether it's playing hide-and-seek, stealing socks, or zooming around, there’s never a dull moment.",
    "Loves to bounce around in a playful frenzy, often performing the funniest 'war dances.' After a long day of mischief, curling up in a hammock for a nap is the perfect way to recharge.",
    "Always on the hunt for adventure, whether that means tunneling under blankets or stashing treasures in secret spots. Loves playtime just as much as snuggling up for a cozy nap.",
    "Endlessly curious and always up to something, whether it's playfully wrestling with toys or investigating every corner of the room. Loves being part of the action and keeping everyone entertained.",
    "A tiny troublemaker with a big heart. Loves climbing, chasing, and making up games, but also enjoys curling up in a warm lap after an energetic day of fun."
  ],
  "Bird" => [
    "Always singing or chirping, bringing a little extra joy to every day. Loves to hop around, explore new perches, and interact with anyone willing to chat back.",
    "Full of personality and always curious, whether it’s watching out the window or playing with toys. Loves attention and will happily whistle or mimic sounds to get it.",
    "A social little companion who enjoys spending time with people. Whether perched on a shoulder or flapping around the cage, always looking for a bit of fun and interaction.",
    "Loves to explore and play, especially with anything that makes noise. Always excited to learn new tricks and eager to bond over treats and gentle head scratches.",
    "A tiny entertainer who fills the room with cheerful sounds. Enjoys company, exploring new toys, and making sure no one forgets they’re the star of the show."
  ],
  "Turtle" => [
    "Loves basking under a warm lamp and watching the world go by. Moves at a slow, steady pace but always finds a way to explore every corner of the tank or enclosure.",
    "Curious and always on the lookout for a snack. Spends the day paddling through water or lounging on a rock, enjoying the simple pleasures of life.",
    "Not in a rush but still full of personality. Loves a good soak, enjoys gentle interactions, and will quickly recognize the sound of food being prepared.",
    "Always observing, whether from a cozy hiding spot or while stretching out in the warmth. Loves routine and appreciates a quiet, stable environment.",
    "A peaceful and gentle companion who enjoys a predictable schedule. Spends the day alternating between swimming, basking, and slowly wandering around."
  ],
  "Fish" => [
    "Always gliding through the water with elegance, darting between plants and decorations. Loves a well-kept tank and perks up when it’s feeding time.",
    "A curious little swimmer who explores every inch of the tank. Loves hiding in caves, weaving through plants, and coming up to the glass to check out what’s happening outside.",
    "Brings life and color to any aquarium, gracefully moving through the water. Quickly learns when it’s mealtime and eagerly swims to the surface for a treat.",
    "Spends the day peacefully drifting or playfully chasing bubbles. Loves a clean, well-maintained tank and enjoys the company of other friendly fish.",
    "Small but full of personality, always active and engaging to watch. Gets excited for food and enjoys swimming in gentle currents or resting in a favorite hiding spot."
  ],
  "Mouse" => [
    "Always on the move, scurrying around and exploring every inch of the enclosure. Loves to climb, burrow, and find the perfect little nook to curl up in for a nap.",
    "A tiny ball of energy who enjoys running on the wheel, nibbling on treats, and investigating anything new. Quick, clever, and always curious about the world around them.",
    "Loves to stash food in little hiding spots and build the coziest nests. Enjoys gentle handling and will happily take a treat right from your hand once trust is built.",
    "Playful and intelligent, always figuring out new ways to navigate tunnels and toys. Enjoys socializing with other mice and thrives in an enriching, interactive environment.",
    "Spends the day alternating between energetic bursts of activity and peaceful moments of rest. Loves chewing on wooden toys, exploring, and snuggling into soft bedding."
  ],
  "Rat" => [
    "Friendly and intelligent, always eager to interact and explore. Loves climbing, solving puzzles, and snuggling up in a cozy hammock after an active play session.",
    "Curious and social, always looking for a new adventure. Enjoys learning tricks, exploring tunnels, and will happily come running for treats and attention.",
    "A playful little companion who thrives on interaction. Loves wrestling with cage mates, hoarding snacks, and perching on shoulders to see what’s going on.",
    "Smart and affectionate, forming strong bonds with people. Enjoys foraging for treats, climbing ropes, and curling up in a warm spot for a well-earned nap.",
    "Always on the go, finding fun in every corner. Loves chasing after toys, nibbling on treats, and figuring out clever ways to navigate obstacles."
  ],
  "Chinchilla" => [
    "Loves zooming around the enclosure, leaping to high perches with incredible agility. A dust bath is the highlight of the day, followed closely by a tasty chew stick.",
    "Soft as a cloud and just as quick! Enjoys bouncing off walls, exploring tunnels, and then settling into a cozy hideout to relax after a busy day of play.",
    "Full of energy and personality, always curious about what’s going on. Can often be found nibbling on hay, rearranging bedding, or hopping onto a shoulder for a closer look.",
    "Prefers a calm, predictable routine but never turns down a fun challenge. Loves chewing on safe wooden toys, digging through hay, and stretching out in a favorite hide.",
    "Most active in the evenings, dashing from ledge to ledge with impressive speed. Always on the lookout for a treat and enjoys gentle interactions on their own terms."
  ],
  "Lizard" => [
    "Basking under a warm light is the perfect way to start the day before exploring every inch of the enclosure. Loves climbing branches and watching the world from a favorite perch.",
    "Curious and calm, always keeping an eye on what's happening outside the tank. Enjoys digging, stretching out in the heat, and occasionally munching on a favorite snack.",
    "Prefers a quiet space with plenty of hiding spots but perks up at feeding time. Quick to investigate new decorations and loves soaking up warmth on a smooth rock.",
    "Slow and steady but full of personality! Likes a well-placed basking spot, a few leafy hideouts, and the occasional adventure climbing branches or burrowing in soft substrate.",
    "Active and alert, often seen flicking a tongue to explore new scents. Enjoys the routine of a warm basking session followed by a well-earned meal."
  ],
  "Goat" => [
    "Always on the move, climbing anything that looks remotely challenging. A playful spirit with a love for head scratches and an endless appetite for tasty snacks.",
    "Friendly and full of mischief, often found trotting around looking for a new adventure. Loves human attention and isn’t shy about nudging for extra treats.",
    "A natural explorer who enjoys hopping onto rocks and nibbling on just about everything. Quick to form bonds and always ready for a good scratch behind the ears.",
    "Full of energy in the morning but happy to lounge in the sun by afternoon. Enjoys the company of other animals and thrives on space to roam and play.",
    "Curious about everything and afraid of nothing! Loves to investigate pockets, chew on shoelaces, and follow people around in hopes of finding an extra snack."
  ],
  "Chicken" => [
    "Always busy scratching the ground, searching for the next tasty snack. Friendly and full of personality, happily clucking along and following people around for treats.",
    "Curious about everything and always the first to investigate a new patch of grass. Loves dust baths in the sun and enjoys perching up high to keep an eye on the world.",
    "A chatty companion who always has something to say. Enjoys roaming around, pecking at little treasures, and settling in a cozy nest box for a well-earned rest.",
    "Happiest when free to explore, scratching and pecking through the day. Quick to recognize familiar faces and will come running when favorite snacks are on the menu.",
    "Loves a good routine, greeting the morning with cheerful clucks and settling down in the evening with the flock. Independent but always happy to be around friendly company."
  ],
}

SPECIES_AGE_RANGES = {
  "Dog" => (2..15),
  "Cat" => (2..20),
  "Rabbit" => (2..12),
  "Hamster" => (1..3),
  "Guinea pig" => (1..8),
  "Ferret" => (2..10),
  "Bird" => (2..20),
  "Turtle" => (2..15),
  "Fish" => (1..10),
  "Mouse" => (1..3),
  "Chinchilla" => (1..15),
  "Lizard" => (1..20),
  "Goat" => (1..15),
  "Chicken" => (1..10)
}

MALE_PET_NAMES = [
  "Buddy", "Charlie", "Max", "Rocky", "Milo", "Simba", "Cooper", "Bailey", "Toby", "Duke",
  "Leo", "Bear", "Oliver", "Finn", "Buster", "Oscar", "Teddy", "Zeus", "Louie", "Rex",
  "Winston", "Rusty", "Sammy", "Jasper", "Chase", "Archie", "Bruno", "Bentley", "Hunter", "Koda",
  "Jack", "Shadow", "Oreo", "Murphy", "Cody", "Moose", "Gizmo", "Diesel", "Marley", "Hank",
  "Jax", "Remy", "Dexter", "Ace", "Harley", "Bandit", "Ranger", "Beau", "Thor", "Benji",
  "Chico", "Frankie", "Goofy", "Casper", "Tucker", "Atlas", "Rocco", "Maverick", "Brady", "Ziggy"
]

FEMALE_PET_NAMES = [
  "Luna", "Bella", "Daisy", "Ruby", "Sadie", "Molly", "Zoey", "Lola", "Maggie", "Nala",
  "Chloe", "Sophie", "Bailey", "Rosie", "Penny", "Coco", "Mia", "Ellie", "Lucy", "Ginger",
  "Roxy", "Stella", "Zara", "Hazel", "Olive", "Willow", "Dolly", "Trixie", "Layla", "Pepper",
  "Minnie", "Angel", "Honey", "Sugar", "Lacey", "Poppy", "Dixie", "Sasha", "Pearl", "Winnie",
  "Nova", "Mocha", "Fiona", "Tasha", "Snowflake", "Tinkerbell", "Misty", "Jasmine", "Violet", "Maple",
  "Biscuit", "Pumpkin", "Peanut", "Sky", "Sable", "Bonnie", "Mochi", "Freya", "Paisley", "Aurora"
]






puts "Creating pets..."
User.where(role: "provider").each do |provider|
  if provider.last_name == "Shelter"
    species = ["Dog", "Cat"].sample
    rand(3..7).times do
      breed = "Other"
      gender = ["Male", "Female"].sample
      pet_name = gender == "Male" ? MALE_PET_NAMES.sample : FEMALE_PET_NAMES.sample
      age = rand(SPECIES_AGE_RANGES[species]) || rand(1..10)
      description = cycle_through_array(DESCRIPTIONS[species])

      pet = Pet.create!(
        location: provider.location,
        provider: provider,
        name: pet_name,
        species: species,
        breed: "Other",
        age: age,
        size: BREED_SIZES[species][breed] || "Medium",
        activity_level: ["Low", "Moderate", "High"].sample,
        gender: gender,
        neutered: [true, false].sample,
        sociable_with_animals: [true, false].sample,
        sociable_with_children: [true, false].sample,
        certified: [true, false].sample,
        description: description
      )

      if STRAY_PHOTOS[pet.species] && STRAY_PHOTOS[pet.species]["Other"]
        puts "Retrieving stray photos for #{pet.species} (Other breed)"

        # Randomly select a set of photos from the "Other" key
        photo_set = cycle_through_array(STRAY_PHOTOS[pet.species]["Other"])
        files = photo_set.map do |filename|
          if pet.species == "Dog"
            file_path = Rails.root.join("app/assets/images/breeds/others/dogs/#{filename}")
          elsif pet.species == "Cat"
            file_path = Rails.root.join("app/assets/images/breeds/others/cats/#{filename}")
          end
          puts "Opening file: #{file_path}"
          { io: File.open(file_path), filename: filename, content_type: "image/jpeg" }
        end

        puts "Attaching stray photos..."
        pet.photos.attach(files)
        puts "Shelter animal photos attached"
      end
      pet.save!
      puts "Pet created: #{pet.name} (#{pet.species}, #{pet.breed})"
      puts "Pet description: #{pet.description}"
    end
  else
    rand(1..2).times do
      species = SPECIES.keys.sample
      breed = cycle_through_array(SPECIES[species].reject { |b| b == "Other" })
      gender = ["Male", "Female"].sample
      pet_name = gender == "Male" ? MALE_PET_NAMES.sample : FEMALE_PET_NAMES.sample
      age = rand(SPECIES_AGE_RANGES[species]) || rand(1..10)

      pet = Pet.create!(
        location: provider.location,
        provider: provider,
        name: pet_name,
        species: species,
        breed: breed,
        age: age,
        size: BREED_SIZES[species][breed] || "Medium",
        activity_level: ["Low", "Moderate", "High"].sample,
        gender: gender,
        neutered: [true, false].sample,
        sociable_with_animals: [true, false].sample,
        sociable_with_children: [true, false].sample,
        certified: [true, false].sample,
        description: DESCRIPTIONS[species].sample
      )

      if BREED_PHOTOS.key?(pet.breed)
        puts "Retrieving photos for #{pet.breed}"

        files = BREED_PHOTOS[pet.breed].map do |filename|
          file_path = Rails.root.join("app/assets/images/breeds/#{filename}")
          puts "Opening file: #{file_path}"
          { io: File.open(file_path), filename: filename, content_type: "image/jpeg" }
        end

        puts "Attaching photos..."
        pet.photos.attach(files)
        puts "Photos attached"
      end

      pet.save!
      puts "Pet created: #{pet.name} (#{pet.species}, #{pet.breed})"
      puts "Pet description: #{pet.description}"
    end
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

class Pet < ApplicationRecord
  acts_as_favoritable
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?

  BREEDS = {
    "Dog" => ["Golden Retriever", "Saint Bernard", "Labrador Retriever", "German Shepherd", "Poodle", "Bulldog",
              "Beagle", "Chihuahua", "Dachshund", "Siberian Husky", "Boxer", "Doberman", "Shih Tzu", "Border Collie",
              "Great Dane", "Rottweiler", "Cocker Spaniel", "Pomeranian", "Maltese", "Australian Shepherd", "Other"],
    "Cat" => ["Siamese", "Persian", "Maine Coon", "Bengal", "Ragdoll", "British Shorthair", "Sphynx", "Abyssinian",
              "Scottish Fold", "Norwegian Forest Cat", "Russian Blue", "Birman", "Savannah", "Oriental Shorthair",
              "Turkish Angora", "Other"],
    "Rabbit" => ["Holland Lop", "Netherland Dwarf", "Flemish Giant", "Lionhead", "Rex", "Mini Lop", "English Angora",
                 "French Lop", "Dutch", "Harlequin", "Other"],
    "Hamster" => ["Syrian Hamster", "Dwarf Campbell Russian Hamster", "Dwarf Winter White Russian Hamster",
                  "Roborovski Hamster", "Chinese Hamster", "Other"],
    "Guinea pig" => ["American", "Abyssinian", "Peruvian", "Teddy", "Silkie", "Texel", "Himalayan", "Baldwin", "Other"],
    "Ferret" => ["Standard", "Albino", "Sable", "Black Sable", "Chocolate", "Cinnamon", "Champagne", "Other"],
    "Bird" => ["Canary", "Finch", "Budgerigar", "Cockatiel", "Lovebird", "Dove", "Pigeon", "Other"],
    "Turtle" => ["Red-Eared Slider", "Box Turtle", "Painted Turtle", "Musk Turtle", "Wood Turtle", "Other"],
    "Fish" => ["Betta", "Goldfish", "Guppy", "Tetra", "Angelfish", "Cichlid", "Molly", "Platy", "Catfish", "Koi",
               "Other"],
    "Mouse" => ["Fancy Mouse", "Hairless Mouse", "Other"],
    "Rat" => ["Dumbo Rat", "Standard Rat", "Hairless Rat", "Other"],
    "Chinchilla" => ["Standard Gray", "Black Velvet", "Beige", "White", "Other"],
    "Lizard" => ["Bearded Dragon", "Leopard Gecko", "Crested Gecko", "Green Iguana", "Blue-Tongued Skink", "Tegu",
                 "Other"],
    "Tarantula" => ["Mexican Red Knee", "Chilean Rose", "Goliath Birdeater", "Pink Toe", "Other"],
    "Frog" => ["White’s Tree Frog", "Poison Dart Frog", "Pacman Frog", "African Clawed Frog", "Other"],
    "Goat" => ["Nubian", "Pygmy", "Boer", "Alpine", "Saanen", "Toggenburg", "Other"],
    "Pig" => ["Pot-Bellied Pig", "Juliana Pig", "Kunekune", "Gloucestershire Old Spot", "Other"],
    "Chicken" => ["Rhode Island Red", "Leghorn", "Plymouth Rock", "Silkie", "Sussex", "Orpington", "Other"],
    "Duck" => ["Pekin", "Mallard", "Muscovy", "Khaki Campbell", "Indian Runner", "Rouen", "Other"],
    "Horse" => ["Thoroughbred", "Quarter Horse", "Arabian", "Friesian", "Clydesdale", "Mustang", "Paint", "Andalusian",
                "Appaloosa", "Other"],
    "Donkey" => ["Standard Donkey", "Miniature Donkey", "Mammoth Donkey", "Other"],
    "Sheep" => ["Merino", "Suffolk", "Dorset", "Hampshire", "Jacob", "Other"],
    "Cow" => ["Holstein", "Jersey", "Angus", "Hereford", "Charolais", "Other"],
    "Alpaca" => ["Huacaya", "Suri", "Other"],
    "Parrot" => ["Macaw", "African Grey", "Cockatoo", "Amazon", "Eclectus", "Conure", "Parakeet", "Other"],
    "Other" => ["Other"]
  }.freeze

  SPECIES = BREEDS.keys.freeze

  SIZE = ["Small", "Medium", "Large"].freeze
  ACTIVITY_LEVEL = ["Low", "Moderate", "High"].freeze
  GENDER = ["Male", "Female"].freeze

  belongs_to :provider, class_name: 'User'
  has_many :interactions, dependent: :destroy
  has_one :adopters, through: :interactions, source: :user
  has_many :chatrooms
  has_many :favoritors, through: :favorites, source: :user

  # photos
  # has_one_attached :photo
  has_many_attached :photos
  # validate :limit_of_photos

  # def limit_of_photos
  #   if images.length > 5
  #     errors.add(:images, "You can only attach up to 5 photos.")
  #   end
  # end

  # attr_accessor :skip_breed_validations, :skip_description_validations
  # attr_accessor :skip_breed_validations

  # Validations trigger on final form submission
  validates :name, presence: true
  validates :species, presence: true, inclusion: { in: SPECIES }
  validates :breed, presence: true
  validates :location, presence: true
  # validates :breed, presence: true
  # validates :description, presence: true, unless: :skip_description_validations
  validates :description, presence: true

  # validate :breed_matches_species, unless: :skip_breed_validations
  validate :breed_matches_species

  private

  def breed_matches_species
    return if species.blank? || breed.blank?

    return if BREEDS[species]&.include?(breed)

    errors.add(:breed, "is not a valid breed for the selected species")
  end

  # def breed_matches_species
  #   if species.blank? || breed.blank?
  #     errors.add(:base, "Species and breed must be provided")
  #     return
  #   end

  #   unless SPECIES[species]&.include?(breed)
  #     errors.add(:breed, "is not a valid breed for the selected species")
  #   end
  # end

  FACTS = [
  "Dogs have been our companions for thousands of years, with domestication dating back to around 13,000 BCE.",
  "The Basenji dog is known for not barking; instead, it makes a unique yodel-like sound.",
  "Greyhounds are not just fast runners; they can reach speeds up to 45 miles per hour.",
  "A Greyhound named 'Breezer' set a world record by running 132 miles in a single day.",
  "Dogs possess a sense of time and can anticipate regular events like feeding or walks.",
  "The world's oldest known dog lived to be 29 years and 5 months.",
  "Dogs have three eyelids, including one that helps keep their eyes moist and protected.",
  "A dog's sense of smell is 10,000 to 100,000 times more sensitive than humans'.",
  "The tallest dog breed is the Great Dane, with some individuals reaching over 7 feet tall when on their hind legs.",
  "Dogs can hear frequencies as high as 65,000 Hz, while humans can hear up to 20,000 Hz.",

  "Cats have been associated with humans for thousands of years, with evidence of domestication dating back to ancient Egypt.",
  "A cat's nose is as unique as a human's fingerprint; no two are alike.",
  "Domestic cats can run up to 30 miles per hour in short bursts.",
  "Cats sleep between 12 to 16 hours a day, making them one of the sleepiest animals.",
  "A group of cats is called a clowder, and a litter of kittens is known as a kindle.",
  "Cats have the ability to rotate their ears 180 degrees, allowing them to hear in all directions.",
  "The world's oldest cat lived to be 38 years and 3 days.",
  "Cats can make over 100 different sounds, while dogs can make about 10.",
  "A cat's whiskers are not just for measuring gaps; they also help them navigate in the dark.",
  "Despite their domestication, cats retain about 95% of their wild hunting instincts.",

  "Rabbits are small mammals found naturally in several parts of the world, including woods, meadows, grasslands, deserts, and wetlands.",
  "Rabbits are herbivores, feeding on grass, nuts, berries, vegetables, and fruits.",
  "Rabbits are crepuscular, meaning they are most active at dawn and dusk.",
  "Rabbits dig burrows to hide and store food, and their large ears allow them to detect predators easily.",
  "Rabbits can jump up to three feet high and can run up to 35 miles per hour.",
  "Rabbits have a 360-degree field of vision due to the placement of their eyes on the sides of their heads.",
  "Rabbits' teeth grow continuously throughout their lives, requiring them to gnaw on things to keep them trimmed.",
  "A group of rabbits is called a herd, and a baby rabbit is known as a kit.",
  "Rabbits can live up to 10 years in captivity with proper care.",
  "Rabbits communicate through body language, including thumping their hind legs to warn of danger.",

  "Hamsters were first discovered in Syria in 1839 and have been kept as pets since the 1940s.",
  "Hamsters are nocturnal creatures, spending most of their active time during the night.",
  "Hamsters can run up to 5 miles on a wheel in a single night.",
  "Hamsters have expandable cheek pouches that can extend from their cheeks to their shoulders, used to store food.",
  "Hamsters' teeth grow continuously throughout their lives, necessitating regular gnawing to keep them at a manageable length.",
  "In the wild, hamsters spend most of their evening digging and foraging for food, living in underground burrows with numerous tunnels and chambers.",
  "Hamsters are solitary animals and can be territorial, sometimes fighting if housed together.",
  "Hamsters have a lifespan of 2 to 3 years, making them one of the shorter-lived pets.",
  "Hamsters communicate through squeaks, hisses, and other vocalizations, especially when threatened.",
  "Hamsters are prone to obesity if overfed or not given enough exercise, so monitoring their diet and activity is essential.",

  "Guinea pigs, or cavies, are native to the Andes mountains in South America and were domesticated around 5,000 BC.",
  "Guinea pigs are social animals and thrive in groups, often communicating with high-pitched squeals.",
  "Guinea pigs are herbivores, feeding on grass, hay, vegetables, and fruits.",
  "Guinea pigs have a lifespan of 4 to 6 years, though some can live up to 8 years with proper care.",
  "Guinea pigs are unable to produce vitamin C on their own and must obtain it through their diet, making them prone to scurvy if not provided with adequate vitamin C-rich foods.",

  "Ferrets are descendants of the European polecat and have been domesticated for over 2,500 years.",
  "Ferrets have a high metabolic rate, requiring frequent feeding—up to three times a day.",
  "Ferrets sleep between 16 to 18 hours a day, often in a curled position.",

  "Birds are the only animals with feathers, a unique feature that aids in flight and temperature regulation.",
  "The average lifespan of a domestic guinea pig is 4 to 6 years, though some can live up to 8 years with proper care.",
  "Guinea pigs are unable to produce vitamin C on their own and must obtain it through their diet, making them prone to scurvy if not provided with adequate vitamin C-rich foods.",

  "Turtles have been around for over 200 million years, making them one of the oldest reptile groups.",
  "Turtles can live both in water and on land, depending on the species.",
  "Some species of turtles can retract their heads and limbs into their shells for protection, while others cannot.",

  "Fish are the oldest group of vertebrates, with fossils dating back over 500 million years.",
  "Fish are cold-blooded, meaning their body temperature matches that of their environment.",
  "Fish communicate through sounds, colors, and movements, using these methods to attract mates, warn of danger, or establish territory.",

  "Mice are highly social animals, often found in groups in the wild.",
  "Mice have a keen sense of hearing and can detect ultrasonic sounds beyond the range of human hearing.",
  "Mice are known for their rapid reproduction rate, with a single pair capable of producing up to 10 litters per year.",

  "Chinchillas are native to the Andes Mountains in South America and are known for their incredibly soft fur, which is denser than that of any other land animal.",
  "Chinchillas are nocturnal, being most active during the night.",
  "Chinchillas require dust baths to maintain their fur, as their dense hair does not allow moisture to penetrate easily.",

  "Lizards are a diverse group of reptiles, with over 6,000 species found worldwide.",
  "Some lizards can regenerate their tails if they lose them, a defense mechanism to escape predators.",

  "Goats are known for their curious and intelligent nature, often exploring their surroundings and solving problems to obtain food.",
  "Goats have rectangular pupils, which provide them with a wide field of vision to detect predators.",
  "Domestic goats are descendants of wild goats from the Middle East and have been kept for their milk, meat, and fiber for thousands of years.",

  "Chickens are descendants of wild red junglefowl native to Southeast Asia and have been domesticated for over 10,000 years.",
  "Chickens are social birds, living in groups known as flocks, and have complex communication systems, including various calls to signal different types of threats.",
  "Chickens have excellent color vision, allowing them to see a broader spectrum of colors than humans."
]

  def self.get_facts
    FACTS
  end
end

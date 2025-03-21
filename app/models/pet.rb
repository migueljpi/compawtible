class Pet < ApplicationRecord
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
  SPECIES = {
    "Dog" => ["Golden Retriever", "Saint Bernard", "Labrador Retriever", "German Shepherd", "Poodle", "Bulldog",
              "Beagle", "Chihuahua", "Dachshund", "Siberian Husky", "Boxer", "Doberman", "Shih Tzu", "Border Collie", "Great Dane", "Rottweiler", "Cocker Spaniel", "Pomeranian", "Maltese", "Australian Shepherd", "Other"],
    "Cat" => ["Siamese", "Persian", "Maine Coon", "Bengal", "Ragdoll", "British Shorthair", "Sphynx", "Abyssinian",
              "Scottish Fold", "Norwegian Forest Cat", "Russian Blue", "Birman", "Savannah", "Oriental Shorthair", "Turkish Angora", "Other"],
    "Rabbit" => ["Holland Lop", "Netherland Dwarf", "Flemish Giant", "Lionhead", "Rex", "Mini Lop", "English Angora",
                 "French Lop", "Dutch", "Harlequin", "Other"],
    "Hamster" => ["Syrian Hamster", "Dwarf Campbell Russian Hamster", "Dwarf Winter White Russian Hamster",
                  "Roborovski Hamster", "Chinese Hamster", "Other"],
    "Guinea Pig" => ["American", "Abyssinian", "Peruvian", "Teddy", "Silkie", "Texel", "Himalayan", "Baldwin", "Other"],
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
  }

  SIZE = ["Small", "Medium", "Large"]
  ACTIVITY_LEVEL = ["Low", "Moderate", "High"]
  GENDER = ["Male", "Female"]

  validates :species, presence: true, inclusion: { in: SPECIES.keys }
  validates :breed, presence: true
  validate :breed_matches_species

  def breed_matches_species
    if species.blank? || breed.blank?
      errors.add(:base, "Species and breed must be provided")
      return
    end

    unless SPECIES[species]&.include?(breed)
      errors.add(:breed, "is not a valid breed for the selected species")
    end
  end

  belongs_to :provider, class_name: 'User'
  has_many :interactions, dependent: :destroy
  has_one :adopters, through: :interactions, source: :user
  validates :name, presence: true
  validates :description, presence: true

# photos
  # has_one_attached :photo
  has_many_attached :photos
  # validate :limit_of_photos

  # def limit_of_photos
  #   if images.length > 5
  #     errors.add(:images, "You can only attach up to 5 photos.")
  #   end
  # end

end

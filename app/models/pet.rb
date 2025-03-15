class Pet < ApplicationRecord
  SPECIES = {
    "Dog" => ["Golden Retriever", "Saint Bernard", "Labrador Retriever", "German Shepherd", "Poodle", "Bulldog", "Beagle", "Chihuahua", "Dachshund", "Siberian Husky", "Boxer", "Doberman", "Shih Tzu", "Border Collie", "Great Dane", "Rottweiler", "Cocker Spaniel", "Pomeranian", "Maltese", "Australian Shepherd", "Other"],
    "Cat" => ["Siamese", "Persian", "Maine Coon", "Bengal", "Ragdoll", "British Shorthair", "Sphynx", "Abyssinian", "Scottish Fold", "Norwegian Forest Cat", "Russian Blue", "Birman", "Savannah", "Oriental Shorthair", "Turkish Angora", "Other"],
    "Rabbit" => ["Holland Lop", "Netherland Dwarf", "Flemish Giant", "Lionhead", "Rex", "Mini Lop", "English Angora", "French Lop", "Dutch", "Harlequin", "Other"],
    "Hamster" => ["Syrian Hamster", "Dwarf Campbell Russian Hamster", "Dwarf Winter White Russian Hamster", "Roborovski Hamster", "Chinese Hamster", "Other"],
    "Guinea Pig" => ["American", "Abyssinian", "Peruvian", "Teddy", "Silkie", "Texel", "Himalayan", "Baldwin", "Other"],
    "Ferret" => ["Standard", "Albino", "Sable", "Black Sable", "Chocolate", "Cinnamon", "Champagne", "Other"],
    "Bird" => ["Canary", "Finch", "Budgerigar", "Cockatiel", "Lovebird", "Dove", "Pigeon", "Other"],
    "Turtle" => ["Red-Eared Slider", "Box Turtle", "Painted Turtle", "Musk Turtle", "Wood Turtle", "Other"],
    "Fish" => ["Betta", "Goldfish", "Guppy", "Tetra", "Angelfish", "Cichlid", "Molly", "Platy", "Catfish", "Koi", "Other"],
    "Mouse" => ["Fancy Mouse", "Hairless Mouse", "Other"],
    "Rat" => ["Dumbo Rat", "Standard Rat", "Hairless Rat", "Other"],
    "Chinchilla" => ["Standard Gray", "Black Velvet", "Beige", "White", "Other"],
    "Lizard" => ["Bearded Dragon", "Leopard Gecko", "Crested Gecko", "Green Iguana", "Blue-Tongued Skink", "Tegu", "Other"],
    "Tarantula" => ["Mexican Red Knee", "Chilean Rose", "Goliath Birdeater", "Pink Toe", "Other"],
    "Frog" => ["White’s Tree Frog", "Poison Dart Frog", "Pacman Frog", "African Clawed Frog", "Other"],
    "Goat" => ["Nubian", "Pygmy", "Boer", "Alpine", "Saanen", "Toggenburg", "Other"],
    "Pig" => ["Pot-Bellied Pig", "Juliana Pig", "Kunekune", "Gloucestershire Old Spot", "Other"],
    "Chicken" => ["Rhode Island Red", "Leghorn", "Plymouth Rock", "Silkie", "Sussex", "Orpington", "Other"],
    "Duck" => ["Pekin", "Mallard", "Muscovy", "Khaki Campbell", "Indian Runner", "Rouen", "Other"],
    "Horse" => ["Thoroughbred", "Quarter Horse", "Arabian", "Friesian", "Clydesdale", "Mustang", "Paint", "Andalusian", "Appaloosa", "Other"],
    "Donkey" => ["Standard Donkey", "Miniature Donkey", "Mammoth Donkey", "Other"],
    "Sheep" => ["Merino", "Suffolk", "Dorset", "Hampshire", "Jacob", "Other"],
    "Cow" => ["Holstein", "Jersey", "Angus", "Hereford", "Charolais", "Other"],
    "Alpaca" => ["Huacaya", "Suri", "Other"],
    "Parrot" => ["Macaw", "African Grey", "Cockatoo", "Amazon", "Eclectus", "Conure", "Parakeet", "Other"],
    "Other" => ["Other"]
  }

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


belongs_to :user
has_many :connections, dependent: :destroy
has_many :users, through: :connections
validates :name, presence: true
validates :description, presence: true
validates :species, presence: true
validates :breed, presence: true



end

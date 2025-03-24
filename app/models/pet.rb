class Pet < ApplicationRecord
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?

  BREEDS = {
    "dog" => ["Golden Retriever", "Saint Bernard", "Labrador Retriever", "German Shepherd", "Poodle", "Bulldog",
              "Beagle", "Chihuahua", "Dachshund", "Siberian Husky", "Boxer", "Doberman", "Shih Tzu", "Border Collie",
              "Great Dane", "Rottweiler", "Cocker Spaniel", "Pomeranian", "Maltese", "Australian Shepherd", "Other"],
    "cat" => ["Siamese", "Persian", "Maine Coon", "Bengal", "Ragdoll", "British Shorthair", "Sphynx", "Abyssinian",
              "Scottish Fold", "Norwegian Forest Cat", "Russian Blue", "Birman", "Savannah", "Oriental Shorthair",
              "Turkish Angora", "Other"],
    "rabbit" => ["Holland Lop", "Netherland Dwarf", "Flemish Giant", "Lionhead", "Rex", "Mini Lop", "English Angora",
                "French Lop", "Dutch", "Harlequin", "Other"],
    "hamster" => ["Syrian Hamster", "Dwarf Campbell Russian Hamster", "Dwarf Winter White Russian Hamster",
                  "Roborovski Hamster", "Chinese Hamster", "Other"],
    "guinea_pig" => ["American", "Abyssinian", "Peruvian", "Teddy", "Silkie", "Texel", "Himalayan", "Baldwin", "Other"],
    "ferret" => ["Standard", "Albino", "Sable", "Black Sable", "Chocolate", "Cinnamon", "Champagne", "Other"],
    "bird" => ["Canary", "Finch", "Budgerigar", "Cockatiel", "Lovebird", "Dove", "Pigeon", "Other"],
    "turtle" => ["Red-Eared Slider", "Box Turtle", "Painted Turtle", "Musk Turtle", "Wood Turtle", "Other"],
    "fish" => ["Betta", "Goldfish", "Guppy", "Tetra", "Angelfish", "Cichlid", "Molly", "Platy", "Catfish", "Koi", "Other"],
    "mouse" => ["Fancy Mouse", "Hairless Mouse", "Other"],
    "rat" => ["Dumbo Rat", "Standard Rat", "Hairless Rat", "Other"],
    "chinchilla" => ["Standard Gray", "Black Velvet", "Beige", "White", "Other"],
    "lizard" => ["Bearded Dragon", "Leopard Gecko", "Crested Gecko", "Green Iguana", "Blue-Tongued Skink", "Tegu", "Other"],
    "tarantula" => ["Mexican Red Knee", "Chilean Rose", "Goliath Birdeater", "Pink Toe", "Other"],
    "frog" => ["White’s Tree Frog", "Poison Dart Frog", "Pacman Frog", "African Clawed Frog", "Other"],
    "goat" => ["Nubian", "Pygmy", "Boer", "Alpine", "Saanen", "Toggenburg", "Other"],
    "pig" => ["Pot-Bellied Pig", "Juliana Pig", "Kunekune", "Gloucestershire Old Spot", "Other"],
    "chicken" => ["Rhode Island Red", "Leghorn", "Plymouth Rock", "Silkie", "Sussex", "Orpington", "Other"],
    "duck" => ["Pekin", "Mallard", "Muscovy", "Khaki Campbell", "Indian Runner", "Rouen", "Other"],
    "horse" => ["Thoroughbred", "Quarter Horse", "Arabian", "Friesian", "Clydesdale", "Mustang", "Paint", "Andalusian",
                "Appaloosa", "Other"],
    "donkey" => ["Standard Donkey", "Miniature Donkey", "Mammoth Donkey", "Other"],
    "sheep" => ["Merino", "Suffolk", "Dorset", "Hampshire", "Jacob", "Other"],
    "cow" => ["Holstein", "Jersey", "Angus", "Hereford", "Charolais", "Other"],
    "alpaca" => ["Huacaya", "Suri", "Other"],
    "parrot" => ["Macaw", "African Grey", "Cockatoo", "Amazon", "Eclectus", "Conure", "Parakeet", "Other"],
    "other" => ["Other"]
  }.freeze

  SPECIES = BREEDS.keys.map { |key| [key.capitalize.gsub('_', ' '), key] }.to_h.freeze

  SIZE = ["Small", "Medium", "Large"].freeze
  ACTIVITY_LEVEL = ["Low", "Moderate", "High"].freeze
  GENDER = ["Male", "Female"].freeze

  belongs_to :provider, class_name: 'User'
  has_many :interactions, dependent: :destroy
  has_one :adopters, through: :interactions, source: :user

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
  attr_accessor :skip_breed_validations

  # Validations trigger on final form submission
  validates :name, presence: true
  validates :species, presence: true, inclusion: { in: SPECIES.values }
  validates :breed, presence: true, unless: :skip_breed_validations
  # validates :breed, presence: true
  # validates :description, presence: true, unless: :skip_description_validations
  validates :description, presence: true

  validate :breed_matches_species, unless: :skip_breed_validations
  # validate :breed_matches_species

  private

  def breed_matches_species
    return if species.blank? || breed.blank?

    unless BREEDS[species]&.include?(breed)
      errors.add(:breed, "is not a valid breed for the selected species")
    end
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

end

class User < ApplicationRecord
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :prompts, dependent: :destroy
  has_many :pets, class_name: "Pet", foreign_key: :provider_id, dependent: :destroy
  has_many :interactions, foreign_key: "adopter_id", dependent: :destroy
  has_many :interacted_pets, through: :interactions, source: :pet
  has_one_attached :photo

  enum role: { adopter: "adopter", provider: "provider" }

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :age, presence: true, numericality: { greater_than: 16, only_integer: true }
  # validates :provider, inclusion: { in: [true, false] }

  def provider?
    role == "provider"
  end

  def adopter?
    role == "adopter"
  end

  validates :location, presence: true, if: :provider?
  validates :about_me, presence: true, if: :provider?

  # has_many :pets, foreign_key: "user_id"
  # has many :interacted_pets, through: :interactions, source: :pet

  # "provider" or "adopter"
end

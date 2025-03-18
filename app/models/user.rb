class User < ApplicationRecord
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :pets, class_name: "Pet", foreign_key: :provider_id, dependent: :destroy
  has_many :interactions, foreign_key: "adopter_id", dependent: :destroy
  has_many :pets, through: :interactions
  has_one_attached :photo

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :age, presence: true, numericality: { greater_than: 16, only_integer: true }
  validates :provider, inclusion: { in: [true, false] }

  def provider?
    provider
  end

  validates :location, presence: true, if: :provider?
  validates :about_me, presence: true, if: :provider?
end

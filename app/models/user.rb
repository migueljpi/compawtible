class User < ApplicationRecord
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :age, presence: true

  def provider?
    provider
  end

  validates :location, presence: true, if: :provider?
  validates :about_me, presence: true, if: :provider?

  has_many :pets, dependent: :destroy
  has_many :connections, dependent: :destroy
  has_many :pets, through: :connections
end

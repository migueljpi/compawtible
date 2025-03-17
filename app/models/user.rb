class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :pets, dependent: :destroy
  has_many :connections, dependent: :destroy
  has_many :pets, through: :connections
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

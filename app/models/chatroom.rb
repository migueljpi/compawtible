class Chatroom < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :users, -> { distinct }, through: :messages
  belongs_to :pet
  has_one :review, dependent: :destroy
end

class Review < ApplicationRecord
  belongs_to :chatroom
  has_one :pet, through: :chatroom
  # check this w TA
    # has_one :adopter, through: :chatroom
  #   has_one :provider, through: :chatroom
  # has_many :users, -> { distinct }, through: :chatroom
  belongs_to :user

  validates :provider_rating, presence: { message: "rating is required" }, inclusion: { in: [0, 1, 2, 3, 4, 5], allow_nil: false },
                          numericality: { only_integer: true }
  validates_uniqueness_of :chatroom_id, message: "can not leave more than one review for the same chat"
  # validates :chatroom, uniqueness: true, message: "can not leave more than one review for the same chat"
end

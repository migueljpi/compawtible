class Review < ApplicationRecord
  belongs_to :chatroom
  has_one :pet, through: :chatroom
  # check this w TA
    # has_one :adopter, through: :chatroom
  #   has_one :provider, through: :chatroom
  # has_many :users, -> { distinct }, through: :chatroom
  belongs_to :user

  validate :validate_provider_rating
  validates_uniqueness_of :chatroom_id, message: "can not leave more than one review for the same chat"

  private

  def validate_provider_rating
    if provider_rating.nil?
      errors.add(:base, "Rating is required")
    elsif !provider_rating.is_a?(Integer) || ![0, 1, 2, 3, 4, 5].include?(provider_rating)
      errors.add(:base, "Rating must be an integer between 0 and 5")
    end
  end

end

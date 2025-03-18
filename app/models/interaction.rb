class Interaction < ApplicationRecord
  belongs_to :adopter, class_name: "User", foreign_key: "adopter_id"
  belongs_to :pet

  # validates :status, presence: true
end

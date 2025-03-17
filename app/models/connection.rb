class Connection < ApplicationRecord
  belongs_to :user
  belongs_to :pet
  # validates :status, presence: true
end

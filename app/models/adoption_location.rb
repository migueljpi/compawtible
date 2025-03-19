class AdoptionLocation < ApplicationRecord
  belongs_to :prompt
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
end

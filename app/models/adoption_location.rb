class AdoptionLocation < ApplicationRecord
  belongs_to :text
  geocoded_by :location
  after_validation :geocode, if: :will_save_change_to_location?
end

class AddTextIdToAdoptionLocations < ActiveRecord::Migration[7.2]
  def change
    add_reference :adoption_locations, :text, null: false, foreign_key: true
  end
end

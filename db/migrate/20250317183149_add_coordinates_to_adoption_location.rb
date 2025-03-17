class AddCoordinatesToAdoptionLocation < ActiveRecord::Migration[7.2]
  def change
    add_column :adoption_locations, :latitude, :float
    add_column :adoption_locations, :longitude, :float
  end
end

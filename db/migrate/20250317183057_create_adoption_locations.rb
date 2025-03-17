class CreateAdoptionLocations < ActiveRecord::Migration[7.2]
  def change
    create_table :adoption_locations do |t|
      t.string :location
      t.integer :radius

      t.timestamps
    end
  end
end

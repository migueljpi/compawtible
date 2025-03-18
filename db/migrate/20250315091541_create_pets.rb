class CreatePets < ActiveRecord::Migration[7.2]
  def change
    create_table :pets do |t|
      t.string :name
      t.string :species
      t.integer :age
      t.string :size
      t.string :activity_level
      t.string :breed
      t.string :gender
      t.text :description
      t.references :provider, null: false, foreign_key: { to_table: :users }
      t.boolean :neutered
      t.string :medical_conditions
      t.boolean :sociable_with_animals
      t.boolean :sociable_with_children
      t.boolean :certified

      t.timestamps
    end
  end
end

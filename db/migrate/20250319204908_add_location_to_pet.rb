class AddLocationToPet < ActiveRecord::Migration[7.2]
  def change
    add_column :pets, :location, :string
  end
end

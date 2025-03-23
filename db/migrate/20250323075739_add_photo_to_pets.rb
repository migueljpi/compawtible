class AddPhotoToPets < ActiveRecord::Migration[7.2]
  def change
    add_column :pets, :photo, :string
  end
end

class AddPetIdToChatrooms < ActiveRecord::Migration[7.2]
  def change
    add_reference :chatrooms, :pet, null: false, foreign_key: true
  end
end

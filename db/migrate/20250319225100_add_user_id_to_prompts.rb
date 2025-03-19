class AddUserIdToPrompts < ActiveRecord::Migration[7.2]
  def change
    add_column :prompts, :user_id, :bigint, null: false
    add_foreign_key :prompts, :users
    add_index :prompts, :user_id
  end
end

class ChangeText < ActiveRecord::Migration[7.2]
  def change
    add_column :texts, :input, :string
    add_column :texts, :output, :string
    remove_column :texts, :content
  end
end

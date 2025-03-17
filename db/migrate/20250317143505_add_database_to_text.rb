class AddDatabaseToText < ActiveRecord::Migration[7.2]
  def change
    add_column :texts, :database, :string
  end
end

class CreateConnections < ActiveRecord::Migration[7.2]
  def change
    create_table :connections do |t|
      t.references :adopter, null: false, foreign_key: { to_table: :users }
      t.references :pet, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end

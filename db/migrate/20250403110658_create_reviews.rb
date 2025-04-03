class CreateReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :reviews do |t|
      t.text :provider_review_content
      t.integer :provider_rating
      t.references :chatroom, null: false, foreign_key: true

      t.timestamps
    end
  end
end

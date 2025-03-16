class CreateTexts < ActiveRecord::Migration[7.2]
  def change
    create_table :texts do |t|
      t.text :content

      t.timestamps
    end
  end
end

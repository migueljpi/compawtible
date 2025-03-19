class RenameTextsToPrompts < ActiveRecord::Migration[7.2]
  def change
    rename_table :texts, :prompts
    rename_column :adoption_locations, :text_id, :prompt_id
  end
end

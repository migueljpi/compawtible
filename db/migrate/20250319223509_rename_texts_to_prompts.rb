class RenameTextsToPrompts < ActiveRecord::Migration[7.2]
  def change
    rename_table :texts, :prompts
  end
end

class RenameSampleToPetsForPromptInPrompts < ActiveRecord::Migration[7.2]
  def change
    rename_column :prompts, :database, :pets_for_prompt
  end
end

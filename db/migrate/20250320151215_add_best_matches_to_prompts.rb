class AddBestMatchesToPrompts < ActiveRecord::Migration[7.2]
  def change
    add_column :prompts, :best_matches, :string, array: true, default: []
  end
end

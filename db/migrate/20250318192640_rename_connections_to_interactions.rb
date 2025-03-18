class RenameConnectionsToInteractions < ActiveRecord::Migration[7.2]
  def change
    rename_table :connections, :interactions
  end
end

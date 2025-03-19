class AddRoleToUsersAndRemoveProvider < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :role, :string
    remove_column :users, :provider, :boolean
  end
end

class AddPendingToFriends < ActiveRecord::Migration[6.1]
  def change
    add_column :friends, :pending, :boolean
  end
end

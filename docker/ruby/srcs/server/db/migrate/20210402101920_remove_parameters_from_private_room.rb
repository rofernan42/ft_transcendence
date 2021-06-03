class RemoveParametersFromPrivateRoom < ActiveRecord::Migration[6.1]
  def change
    remove_column :private_rooms, :user1
    remove_column :private_rooms, :user2
  end
end

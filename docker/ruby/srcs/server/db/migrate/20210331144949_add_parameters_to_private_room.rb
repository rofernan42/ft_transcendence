class AddParametersToPrivateRoom < ActiveRecord::Migration[6.1]
  def change
    add_column :private_rooms, :user1, :bigint, null: false
    add_column :private_rooms, :user2, :bigint, null: false
  end
end
